import 'dart:developer';
import 'package:healthonify_mobile/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:healthonify_mobile/constants/theme_data.dart';
import 'package:healthonify_mobile/models/health_care/health_care_prescriptions_model.dart';
import 'package:healthonify_mobile/models/http_exception.dart';
import 'package:healthonify_mobile/models/wm/health_record_model.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/health_records/health_record_provider.dart';
import 'package:healthonify_mobile/screens/client_screens/health_locker/add_health_record.dart';
import 'package:healthonify_mobile/screens/client_screens/health_locker/edit_health_record.dart';
import 'package:healthonify_mobile/widgets/tab_app_bar.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

enum PopUp { edit, delete }

class HealthLockerScreen extends StatefulWidget {
  final String? userId;
  const HealthLockerScreen({Key? key, this.userId}) : super(key: key);

  @override
  State<HealthLockerScreen> createState() => _HealthLockerScreenState();
}

class _HealthLockerScreenState extends State<HealthLockerScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  List<HealthRecord> healthRecords = [];
  List<HealthCarePrescriptionModel> healthCarePrescriptions = [];

  Future fetchHealthRecords() async {
    String userId = widget.userId ??
        Provider.of<UserData>(context, listen: false).userData.id!;
    try {
      healthRecords =
          await Provider.of<HealthRecordProvider>(context, listen: false)
              .getHealthRecords(userId);

      log('fetched health records');
    } on HttpException catch (e) {
      log(e.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e) {
      log("Error getting health records $e");
      Fluttertoast.showToast(msg: "Unable to fetch health records");
    }
  }

  void popFunc() {
    Navigator.pop(context);
  }

  Future deleteRecords(String recId) async {
    try {
      await Provider.of<HealthRecordProvider>(context, listen: false)
          .deleteHealthRecord(recId);
      for (var ele in healthRecords) {
        if (ele.id == recId) {
          healthRecords.removeAt(healthRecords.indexOf(ele));
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

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 6, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TabAppBar(
        appBarTitle: 'Health Locker',
        bottomWidget: ColoredBox(
            color: Theme.of(context).appBarTheme.backgroundColor!,
            child: customTabBar(context, tabController)),
      ),
      body: FutureBuilder(
        future: fetchHealthRecords(),
        builder: (context, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Scaffold(
                    body: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Scaffold(
                    body: DefaultTabController(
                      length: 5,
                      child: TabBarView(
                        controller: tabController,
                        physics: const BouncingScrollPhysics(),
                        children: [
                          build1(),
                          build2(),
                          build6(),
                          build3(),
                          build4(),
                          build5(),
                        ],
                      ),
                    ),
                    bottomNavigationBar:
                        preferences.getString("role") != "ROLE_EXPERT"
                            ? Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  gradient: orangeGradient,
                                ),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return const AddHealthRecord();
                                    })).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: Center(
                                    child: Text(
                                      'Add new health record',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge!
                                          .copyWith(color: whiteColor),
                                    ),
                                  ),
                                ),
                              )
                            : const SizedBox(),
                  ),
      ),
    );
  }

  Widget build1() {
    return healthRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            itemCount: healthRecords.length,
            itemBuilder: (context, index) {
              String formatDate =
                  DateFormat('d MMM').format(healthRecords[index].date!);
              String formatTime = healthRecords[index].time!;
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(healthRecords[index].mediaLink!),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    leading: healthRecords[index].mediaLink == null
                        ? const SizedBox(width: 40)
                        : Image.asset('assets/icons/pdf.png', width: 40),
                    trailing: SizedBox(
                      width: 98,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Share.share(healthRecords[index].mediaLink!);
                            },
                            icon: const Icon(
                              Icons.share_rounded,
                              size: 24,
                              color: Colors.grey,
                            ),
                            splashRadius: 20,
                          ),
                          PopupMenuButton(
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
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                PopupMenuItem(
                                  value: PopUp.delete,
                                  child: Text(
                                    'Delete',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                              ];
                            },
                            onSelected: (value) {
                              if (value == PopUp.edit) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditHealthRecord(
                                    recordId: healthRecords[index].id!,
                                    healthRecord: healthRecords[index],
                                  );
                                })).then((value) {
                                  setState(() {});
                                });
                              } else if (value == PopUp.delete) {
                                deleteAlert(healthRecords[index].id!);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                healthRecords[index].reportName ?? "No title",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                '$formatDate at $formatTime',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Divider(
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
              'Would you like this delete this health record?',
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

  Widget build2() {
    List<HealthRecord> prescriptionRecords = [];
    for (var element in healthRecords) {
      if (element.reportType == 'prescription') {
        prescriptionRecords.add(element);
      }
    }
    return prescriptionRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            itemCount: prescriptionRecords.length,
            itemBuilder: (context, index) {
              String formatDate =
                  DateFormat('d MMM').format(prescriptionRecords[index].date!);
              String formatTime = prescriptionRecords[index].time!;
              return ListTile(
                onTap: () async {
                  await launchUrl(
                    Uri.parse(prescriptionRecords[index].mediaLink!),
                    mode: LaunchMode.externalApplication,
                  );
                },
                leading: prescriptionRecords[index].mediaLink == null
                    ? const SizedBox(width: 40)
                    : Image.asset('assets/icons/pdf.png', width: 40),
                trailing: SizedBox(
                  width: 98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Share.share(prescriptionRecords[index].mediaLink!);
                        },
                        icon: const Icon(
                          Icons.share_rounded,
                          size: 24,
                          color: Colors.grey,
                        ),
                        splashRadius: 20,
                      ),
                      PopupMenuButton(
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
                              return EditHealthRecord(
                                recordId: healthRecords[index].id!,
                                healthRecord: healthRecords[index],
                              );
                            })).then((value) {
                              setState(() {});
                            });
                          } else if (value == PopUp.delete) {
                            deleteAlert(healthRecords[index].id!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            prescriptionRecords[index].reportName ?? "No title",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$formatDate at $formatTime',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                          Divider(
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
  }

  Widget build3() {
    List<HealthRecord> hraRecords = [];
    for (var element in healthRecords) {
      if (element.reportType == 'hra') {
        hraRecords.add(element);
      }
    }
    return hraRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            itemCount: hraRecords.length,
            itemBuilder: (context, index) {
              String formatDate =
                  DateFormat('d MMM').format(hraRecords[index].date!);
              String formatTime = hraRecords[index].time!;
              return ListTile(
                onTap: () async {
                  await launchUrl(
                    Uri.parse(hraRecords[index].mediaLink!),
                    mode: LaunchMode.externalApplication,
                  );
                },
                leading: hraRecords[index].mediaLink == null
                    ? const SizedBox(width: 40)
                    : Image.asset('assets/icons/pdf.png', width: 40),
                trailing: SizedBox(
                  width: 98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Share.share(hraRecords[index].mediaLink!);
                        },
                        icon: const Icon(
                          Icons.share_rounded,
                          size: 24,
                          color: Colors.grey,
                        ),
                        splashRadius: 20,
                      ),
                      PopupMenuButton(
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
                              return EditHealthRecord(
                                recordId: healthRecords[index].id!,
                                healthRecord: healthRecords[index],
                              );
                            })).then((value) {
                              setState(() {});
                            });
                          } else if (value == PopUp.delete) {
                            deleteAlert(healthRecords[index].id!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hraRecords[index].reportName ?? "No title",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$formatDate at $formatTime',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                          Divider(
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
  }

  Widget build4() {
    List<HealthRecord> ecgRecords = [];
    for (var element in healthRecords) {
      if (element.reportType == 'ecg') {
        ecgRecords.add(element);
      }
    }
    return ecgRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            itemCount: ecgRecords.length,
            itemBuilder: (context, index) {
              String formatDate =
                  DateFormat('d MMM').format(ecgRecords[index].date!);
              String formatTime = ecgRecords[index].time!;
              return ListTile(
                onTap: () async {
                  await launchUrl(
                    Uri.parse(ecgRecords[index].mediaLink!),
                    mode: LaunchMode.externalApplication,
                  );
                },
                leading: ecgRecords[index].mediaLink == null
                    ? const SizedBox(width: 40)
                    : Image.asset('assets/icons/pdf.png', width: 40),
                trailing: SizedBox(
                  width: 98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Share.share(ecgRecords[index].mediaLink!);
                        },
                        icon: const Icon(
                          Icons.share_rounded,
                          size: 24,
                          color: Colors.grey,
                        ),
                        splashRadius: 20,
                      ),
                      PopupMenuButton(
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
                              return EditHealthRecord(
                                recordId: healthRecords[index].id!,
                                healthRecord: healthRecords[index],
                              );
                            })).then((value) {
                              setState(() {});
                            });
                          } else if (value == PopUp.delete) {
                            deleteAlert(healthRecords[index].id!);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ecgRecords[index].reportName ?? "No title",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$formatDate at $formatTime',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                          Divider(
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
  }

  Widget build5() {
    List<HealthRecord> otherRecords = [];
    for (var element in healthRecords) {
      if (element.reportType != 'prescription' &&
          element.reportType != 'hra' &&
          element.reportType != 'ecg') {
        otherRecords.add(element);
      }
    }
    return otherRecords.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            itemCount: otherRecords.length,
            itemBuilder: (context, index) {
              String formatDate =
                  DateFormat('d MMM').format(otherRecords[index].date!);
              String formatTime = otherRecords[index].time!;
              return ListTile(
                onTap: () async {
                  await launchUrl(
                    Uri.parse(otherRecords[index].mediaLink!),
                    mode: LaunchMode.externalApplication,
                  );
                },
                leading: otherRecords[index].mediaLink == null
                    ? const SizedBox(width: 40)
                    : Image.asset('assets/icons/pdf.png', width: 40),
                trailing: SizedBox(
                  width: 98,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Share.share(otherRecords[index].mediaLink!);
                        },
                        icon: const Icon(
                          Icons.share_rounded,
                          size: 24,
                          color: Colors.grey,
                        ),
                        splashRadius: 20,
                      ),
                      PopupMenuButton(
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
                            Navigator.pop(context);
                          } else if (value == PopUp.delete) {
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            otherRecords[index].reportName ?? "No title",
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          Text(
                            '$formatDate at $formatTime',
                            style:
                                Theme.of(context).textTheme.bodySmall!.copyWith(
                                      color: Colors.grey[600],
                                    ),
                          ),
                          Divider(
                            color: Colors.grey[600],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
          );
  }

  Widget build6() {
    return healthCarePrescriptions.isEmpty
        ? Center(
            child: Text(
              'No Records Available',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            padding: const EdgeInsets.only(top: 20),
            itemCount: healthCarePrescriptions.length,
            itemBuilder: (context, index) {
              String formatDate = DateFormat('d MMM')
                  .format(healthCarePrescriptions[index].date!);
              String formatTime = DateFormat('h:mm a')
                  .format(healthCarePrescriptions[index].time!);
              return Column(
                children: [
                  ListTile(
                    onTap: () async {
                      await launchUrl(
                        Uri.parse(healthCarePrescriptions[index].hcMediaLink!),
                        mode: LaunchMode.externalApplication,
                      );
                    },
                    leading: healthCarePrescriptions[index].hcMediaLink == null
                        ? const SizedBox(width: 40)
                        : Image.asset('assets/icons/pdf.png', width: 40),
                    trailing: SizedBox(
                      width: 98,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            onPressed: () {
                              Share.share(
                                  healthCarePrescriptions[index].hcMediaLink!);
                            },
                            icon: const Icon(
                              Icons.share_rounded,
                              size: 24,
                              color: Colors.grey,
                            ),
                            splashRadius: 20,
                          ),
                        ],
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                healthCarePrescriptions[index].reportType ??
                                    "No title",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                // 'healthcare prescription',
                                '$formatDate at $formatTime',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(
                                      color: Colors.grey[600],
                                    ),
                              ),
                              Divider(
                                color: Colors.grey[600],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
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
              'PRESCRIPTION',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'HEALTHCARE',
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('HRA'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('ECG'),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text('OTHERS'),
          ),
        ],
        labelStyle: Theme.of(context).textTheme.labelMedium,
        indicatorColor: Colors.red,
        indicatorWeight: 2.5,
      );
}
