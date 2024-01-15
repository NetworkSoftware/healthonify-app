import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/func/loading_dialog_container.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/insurance_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/insurance_locker/insurance_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/insurance_locker/add_insurance.dart';
import 'package:healthonify_mobile/screens/client_screens/insurance_locker/edit_insurance_record.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopUp { edit, delete }

class InsuranceLockerScreen extends StatefulWidget {
  const InsuranceLockerScreen({Key? key}) : super(key: key);

  @override
  State<InsuranceLockerScreen> createState() => _InsuranceLockerScreenState();
}

class _InsuranceLockerScreenState extends State<InsuranceLockerScreen>
    with TickerProviderStateMixin {
  List<InsuranceModel> insuranceRecords = [];
  Future fetchInsuranceRecords() async {
    String userId = Provider.of<UserData>(context).userData.id!;
    try {
      insuranceRecords =
          await Provider.of<InsuranceProvider>(context, listen: false)
              .getHealthRecords(userId);
      log('fetched insurance records');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting health records $e");
      Fluttertoast.showToast(msg: "Unable to fetch health records");
    }
  }

  Future deleteRecords(String recId) async {
    popFunc();
    LoadingDialog().onLoadingDialog("Deleting", context);
    try {
      await Provider.of<InsuranceProvider>(context, listen: false)
          .deleteInsuranceRecord(recId);
      for (var ele in insuranceRecords) {
        if (ele.id == recId) {
          insuranceRecords.removeAt(insuranceRecords.indexOf(ele));
          setState(() {});
          break;
        }
      }
      log('deleted health record');
      popFunc();
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error deleting health record $e");
      Fluttertoast.showToast(msg: "Unable to delete health record");
    }
  }

  void popFunc() {
    Navigator.of(context, rootNavigator: true).pop();
  }

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 4, vsync: this);
    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'Insurance Locker',
        bottomWidget: ColoredBox(
            color: Theme.of(context).appBarTheme.backgroundColor!,
            child: customTabBar(context, tabController)),
      ),
      body: FutureBuilder(
        future: fetchInsuranceRecords(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SafeArea(
                    child: DefaultTabController(
                      length: 4,
                      child: TabBarView(
                        controller: tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          build1(),
                          build2(),
                          build3(),
                          build4(),
                        ],
                      ),
                    ),
                  ),
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: BoxDecoration(gradient: orangeGradient),
        child: InkWell(
          onTap: () {
            showPopUp(context);
          },
          child: Center(
            child: Text(
              'Add new insurance record',
              style: Theme.of(context).textTheme.labelLarge!.copyWith(
                    color: whiteColor,
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget build1() {
    return insuranceRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: insuranceRecords.length,
            itemBuilder: (context, index) {
              DateTime expiresDate = DateTime.parse(
                  insuranceRecords[index].expiryDate ?? '2022-20-20');
              String? formatExpiryDate =
                  DateFormat('d MMM yyyy').format(expiresDate);
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(insuranceRecords[index].mediaLink!),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    leading: Image.asset(
                      'assets/icons/file.png',
                      height: 30,
                      width: 30,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          insuranceRecords[index].insuranceCompanyName ??
                              "No title",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'expires at $formatExpiryDate',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 28,
                        color: Colors.grey,
                      ),
                      color: Theme.of(context).canvasColor,
                      splashRadius: 20,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: PopUp.edit,
                            child: Text(
                              'Edit',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          PopupMenuItem(
                            value: PopUp.delete,
                            child: Text(
                              'Delete',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == PopUp.edit) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditInsuranceRecord(
                              recordId: insuranceRecords[index].id!,
                              insuranceRecord: insuranceRecords[index],
                            );
                          })).then((value) {
                            setState(() {});
                          });
                        } else if (value == PopUp.delete) {
                          deleteAlert(insuranceRecords[index].id!);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[600],
              );
            },
          );
  }

  Widget build2() {
    List<InsuranceModel> healthInsuranceRecords = [];
    for (var element in insuranceRecords) {
      if (element.insuranceType == 'Health Insurance') {
        healthInsuranceRecords.add(element);
      }
    }
    return healthInsuranceRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: healthInsuranceRecords.length,
            itemBuilder: (context, index) {
              DateTime expiresDate =
                  DateTime.parse(healthInsuranceRecords[index].expiryDate!);
              String? formatExpiryDate =
                  DateFormat('d MMM yyyy').format(expiresDate);
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(healthInsuranceRecords[index].mediaLink!),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    leading: Image.asset(
                      'assets/icons/file.png',
                      height: 30,
                      width: 30,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          healthInsuranceRecords[index].insuranceCompanyName ??
                              "No title",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'expires at $formatExpiryDate',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 28,
                        color: Colors.grey,
                      ),
                      color: Theme.of(context).canvasColor,
                      splashRadius: 20,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: PopUp.edit,
                            child: Text(
                              'Edit',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          PopupMenuItem(
                            value: PopUp.delete,
                            child: Text(
                              'Delete',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == PopUp.edit) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditInsuranceRecord(
                              recordId: healthInsuranceRecords[index].id!,
                              insuranceRecord: insuranceRecords[index],
                            );
                          })).then((value) {
                            setState(() {});
                          });
                        } else if (value == PopUp.delete) {
                          deleteAlert(healthInsuranceRecords[index].id!);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[600],
              );
            },
          );
  }

  Widget build3() {
    List<InsuranceModel> lifeInsuranceRecords = [];
    for (var element in insuranceRecords) {
      if (element.insuranceType == 'Life Insurance') {
        lifeInsuranceRecords.add(element);
      }
    }
    return lifeInsuranceRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: lifeInsuranceRecords.length,
            itemBuilder: (context, index) {
              DateTime expiresDate =
                  DateTime.parse(lifeInsuranceRecords[index].expiryDate!);
              String? formatExpiryDate =
                  DateFormat('d MMM yyyy').format(expiresDate);
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(lifeInsuranceRecords[index].mediaLink!),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    leading: Image.asset(
                      'assets/icons/file.png',
                      height: 30,
                      width: 30,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          lifeInsuranceRecords[index].insuranceCompanyName ??
                              "No title",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'expires at $formatExpiryDate',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 28,
                        color: Colors.grey,
                      ),
                      color: Theme.of(context).canvasColor,
                      splashRadius: 20,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: PopUp.edit,
                            child: Text(
                              'Edit',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          PopupMenuItem(
                            value: PopUp.delete,
                            child: Text(
                              'Delete',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == PopUp.edit) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditInsuranceRecord(
                              recordId: lifeInsuranceRecords[index].id!,
                              insuranceRecord: insuranceRecords[index],
                            );
                          })).then((value) {
                            setState(() {});
                          });
                        } else if (value == PopUp.delete) {
                          deleteAlert(lifeInsuranceRecords[index].id!);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[600],
              );
            },
          );
  }

  Widget build4() {
    List<InsuranceModel> motorInsuranceRecords = [];
    for (var element in insuranceRecords) {
      if (element.insuranceType == 'Motor Insurance') {
        motorInsuranceRecords.add(element);
      }
    }
    return motorInsuranceRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: motorInsuranceRecords.length,
            itemBuilder: (context, index) {
              DateTime expiresDate =
                  DateTime.parse(motorInsuranceRecords[index].expiryDate!);
              String? formatExpiryDate =
                  DateFormat('d MMM yyyy').format(expiresDate);
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(motorInsuranceRecords[index].mediaLink!),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    leading: Image.asset(
                      'assets/icons/file.png',
                      height: 30,
                      width: 30,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          motorInsuranceRecords[index].insuranceCompanyName ??
                              "No title",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(
                          height: 4,
                        ),
                        Text(
                          'expires at $formatExpiryDate',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: Colors.grey[600],
                                  ),
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        size: 28,
                        color: Colors.grey,
                      ),
                      color: Theme.of(context).canvasColor,
                      splashRadius: 20,
                      itemBuilder: (context) {
                        return [
                          PopupMenuItem(
                            value: PopUp.edit,
                            child: Text(
                              'Edit',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                          PopupMenuItem(
                            value: PopUp.delete,
                            child: Text(
                              'Delete',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        ];
                      },
                      onSelected: (value) {
                        if (value == PopUp.edit) {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditInsuranceRecord(
                              recordId: motorInsuranceRecords[index].id!,
                              insuranceRecord: insuranceRecords[index],
                            );
                          })).then((value) {
                            setState(() {});
                          });
                        } else if (value == PopUp.delete) {
                          deleteAlert(motorInsuranceRecords[index].id!);
                        }
                      },
                    ),
                  ),
                ],
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.grey[600],
              );
            },
          );
  }

  void showPopUp(context) {
    List options = [
      'Life Insurance',
      'Health Insurance',
      'Motor Insurance',
    ];
    List insuranceIcons = [
      'assets/icons/life_insurance.png',
      'assets/icons/health_insurance.png',
      'assets/icons/motor_insurance.png',
    ];
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Dialog(
            backgroundColor: Theme.of(context).canvasColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      'Select an option',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Card(
                            elevation: 0,
                            color: Theme.of(context).colorScheme.background,
                            child: InkWell(
                              onTap: () async {
                                Navigator.pop(context);
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return AddInsuranceScreen(
                                    insuranceType: options[index],
                                  );
                                })).then((value) {
                                  setState(() {});
                                });
                              },
                              borderRadius: BorderRadius.circular(10),
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      insuranceIcons[index],
                                      height: 24,
                                      width: 24,
                                    ),
                                    const Spacer(),
                                    Text(
                                      options[index],
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void deleteAlert(String recordId) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
            title: Text(
              'Delete this record?',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            content: Text(
              'Would you like this delete this insurance record?',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('CANCEL'),
              ),
              TextButton(
                onPressed: () async {
                  await deleteRecords(recordId);
                },
                child: const Text('DELETE'),
              ),
            ],
          );
        });
  }

  TabBar customTabBar(context, TabController controller) => TabBar(
        controller: controller,
        isScrollable: true,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        tabs: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('ALL RECORDS'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'HEALTH INSURANCE',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('LIFE INSURANCE'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('MOTOR INSURANCE'),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: Colors.red,
        indicatorWeight: 2.5,
      );
}
