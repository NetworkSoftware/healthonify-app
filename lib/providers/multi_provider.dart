import 'package:healthonify_mobile/func/trackers/step_tracker.dart';
import 'package:healthonify_mobile/providers/all_consultations_data.dart';
import 'package:healthonify_mobile/providers/batch_providers/batch_provider.dart';
import 'package:healthonify_mobile/providers/experts/expert_earnings_provider.dart';
import 'package:healthonify_mobile/providers/experts/store_prescription_provider.dart';
import 'package:healthonify_mobile/providers/experts/upload_certificates_provider.dart';
import 'package:healthonify_mobile/providers/fitness_form_provider/get_fitness_form.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_plans_provider.dart';
import 'package:healthonify_mobile/providers/health_care/my_reports_provider/my_reports_provider.dart';
import 'package:healthonify_mobile/providers/health_care/pill_reminder_provider.dart';
import 'package:healthonify_mobile/providers/labs_provider/get_cities.dart';
import 'package:healthonify_mobile/providers/lifestyle_providers/lifestyle_providers.dart';
import 'package:healthonify_mobile/providers/manage_weight_provider.dart';
import 'package:healthonify_mobile/providers/my_medication/medication_provider.dart';
import 'package:healthonify_mobile/providers/physiotherapy/physio_therapy_plans_provider.dart';
import 'package:healthonify_mobile/providers/start_live_session.dart';
import 'package:healthonify_mobile/providers/trackers/all_tracker_data.dart';
import 'package:healthonify_mobile/providers/auth/login_data.dart';
import 'package:healthonify_mobile/providers/auth/signup_data.dart';
import 'package:healthonify_mobile/providers/blogs_provider/blogs_provider.dart';
import 'package:healthonify_mobile/providers/body_measurements_provider.dart';
import 'package:healthonify_mobile/providers/challenges_providers/challenges_provider.dart';
import 'package:healthonify_mobile/providers/community_provider/community_provider.dart';
import 'package:healthonify_mobile/providers/diet_plans/diet_plans_provider.dart';
import 'package:healthonify_mobile/providers/exercises/exercises_data.dart';
import 'package:healthonify_mobile/providers/experts/add_client_provider.dart';
import 'package:healthonify_mobile/providers/fitness_tools/fitness_tools_data.dart';
import 'package:healthonify_mobile/providers/fitness_tools/macro_calc_provider.dart';
import 'package:healthonify_mobile/providers/get_chat_details.dart';
import 'package:healthonify_mobile/providers/get_consultation.dart';
import 'package:healthonify_mobile/providers/health_care/ayurveda_provider/ayurveda_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_consultations_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_plans/health_care_plans_provider.dart';
import 'package:healthonify_mobile/providers/health_care/health_care_provider.dart';
import 'package:healthonify_mobile/providers/health_care/medical_history_provider/medical_history_provider.dart';
import 'package:healthonify_mobile/providers/health_care/second_opinion_provider/second_opinion_provider.dart';
import 'package:healthonify_mobile/providers/health_risk_assessment/hra_provider.dart';
import 'package:healthonify_mobile/providers/labs_provider/labs_provider.dart';
import 'package:healthonify_mobile/providers/live_well_providers/live_well_provider.dart';
import 'package:healthonify_mobile/providers/physiotherapy/enquiry_form_data.dart';
import 'package:healthonify_mobile/providers/expertise/expertise_data.dart';
import 'package:healthonify_mobile/providers/reminders/reminder_provider.dart';
import 'package:healthonify_mobile/providers/tracker_data/home_tracker_data.dart';
import 'package:healthonify_mobile/providers/trackers/calorie_tracker_provider.dart';
import 'package:healthonify_mobile/providers/trackers/heart_rate.dart';
import 'package:healthonify_mobile/providers/trackers/sleep_tracker.dart';
import 'package:healthonify_mobile/providers/trackers/steps_tracker.dart';
import 'package:healthonify_mobile/providers/vitals/blood_glucose_data.dart';
import 'package:healthonify_mobile/providers/vitals/blood_pressure_data.dart';
import 'package:healthonify_mobile/providers/vitals/hba1c_data.dart';
import 'package:healthonify_mobile/providers/trackers/water_intake.dart';
import 'package:healthonify_mobile/providers/weight_logs.dart';
import 'package:healthonify_mobile/providers/weight_management/assign_wm_package.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_log_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/diet_plan_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/dishes_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/get_wm_package_type.dart';
import 'package:healthonify_mobile/providers/weight_management/insurance_locker/insurance_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_goal/weight_goal_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/workout_data.dart';
import 'package:healthonify_mobile/providers/weight_management/health_records/health_record_provider.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_consultations_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_packages.dart';
import 'package:healthonify_mobile/providers/experts/subscriptions_data.dart';
import 'package:healthonify_mobile/providers/experts_data.dart';
import 'package:healthonify_mobile/providers/forgot_psswd.dart';
import 'package:healthonify_mobile/providers/notifications_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/physio_packages_data.dart';
import 'package:healthonify_mobile/providers/experts/patients_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/consult_now_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/health_data.dart';
import 'package:healthonify_mobile/providers/physiotherapy/session_data.dart';
import 'package:healthonify_mobile/providers/user_data.dart';
import 'package:healthonify_mobile/providers/weight_management/weight_mangement_enq.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_sessions_data.dart';
import 'package:healthonify_mobile/providers/weight_management/wm_subscriptions_data.dart';
import 'package:healthonify_mobile/providers/womens_special/womens_special_provider.dart';
import 'package:healthonify_mobile/providers/workout_analysis_provider/workout_analysis_provider.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class MultiProv {
  static List<SingleChildWidget> providersArray = [
    ChangeNotifierProvider(create: (_) => PillReminderProvider()),
    ChangeNotifierProvider(create: (_) => LoginData()),
    ChangeNotifierProvider(create: (_) => SignUpData()),
    ChangeNotifierProvider(create: (_) => UserData()),
    ChangeNotifierProvider(create: (_) => AddClientProvider()),
    ChangeNotifierProvider(create: (_) => HomeTrackerProvider()),
    ChangeNotifierProvider(create: (_) => FitnessFormProvider()),
    ChangeNotifierProvider(create: (_) => EnquiryData()),
    ChangeNotifierProvider(create: (_) => WorkoutAnalysisProvider()),
    ChangeNotifierProvider(create: (_) => ExpertiseData()),
    ChangeNotifierProvider(create: (_) => ExpertEarningsProvider()),
    ChangeNotifierProvider(create: (_) => BatchProvider()),
    ChangeNotifierProvider(create: (_) => PhysioPackagesData()),
    ChangeNotifierProvider(create: (_) => WmPackagesData()),
    ChangeNotifierProvider(create: (_) => GetWmPackageType()),
    ChangeNotifierProvider(create: (_) => AssignWmPackage()),
    ChangeNotifierProvider(create: (_) => ExpertsData()),
    ChangeNotifierProvider(create: (_) => StartLiveSessionProvider()),
    ChangeNotifierProvider(
        create: (_) => UploadCertificatesAndAvailabilityProvider()),
    ChangeNotifierProvider(create: (_) => ConsultNowData()),
    ChangeNotifierProvider(create: (_) => SessionData()),
    ChangeNotifierProvider(create: (_) => HealthData()),
    ChangeNotifierProvider(create: (_) => SubscriptionsData()),
    ChangeNotifierProvider(create: (_) => NotificationsData()),
    ChangeNotifierProvider(create: (_) => WMEnqProvider()),
    ChangeNotifierProvider(create: (_) => ForgotPasswordProvider()),
    ChangeNotifierProvider(create: (_) => PatientsData()),
    ChangeNotifierProvider(create: (_) => WmPackagesData()),
    ChangeNotifierProvider(create: (_) => GetChatDetails()),
    ChangeNotifierProvider(create: (_) => GetConsultation()),
    ChangeNotifierProvider(create: (_) => WeightLogs()),
    ChangeNotifierProvider(create: (_) => BodyMeasurementsProvider()),
    ChangeNotifierProvider(create: (_) => WaterIntakeProvider()),
    ChangeNotifierProvider(create: (_) => WorkoutProvider()),
    ChangeNotifierProvider(create: (_) => DietPlanProvider()),
    ChangeNotifierProvider(create: (_) => DishProvider()),
    ChangeNotifierProvider(create: (_) => SleepTrackerProvider()),
    ChangeNotifierProvider(create: (_) => WmConsultationData()),
    ChangeNotifierProvider(create: (_) => WmSubscriptionsData()),
    ChangeNotifierProvider(create: (_) => WmSessionsData()),
    ChangeNotifierProvider(create: (_) => AllTrackersData()),
    ChangeNotifierProvider(create: (_) => FitnessToolsData()),
    ChangeNotifierProvider(create: (_) => BloodPressureData()),
    ChangeNotifierProvider(create: (_) => HbA1cData()),
    ChangeNotifierProvider(create: (_) => BloodGlucoseData()),
    ChangeNotifierProvider(create: (_) => HealthRecordProvider()),
    ChangeNotifierProvider(create: (_) => MacroCalculatorProvider()),
    ChangeNotifierProvider(create: (_) => CommunityProvider()),
    ChangeNotifierProvider(create: (_) => StepTracker()),
    ChangeNotifierProvider(create: (_) => ReminderProvider()),
    ChangeNotifierProvider(create: (_) => ExercisesData()),
    ChangeNotifierProvider(create: (_) => StepTrackerProvider()),
    ChangeNotifierProvider(create: (_) => InsuranceProvider()),
    ChangeNotifierProvider(create: (_) => WeightGoalProvider()),
    ChangeNotifierProvider(create: (_) => HraProvider()),
    ChangeNotifierProvider(create: (_) => HealthCareProvider()),
    ChangeNotifierProvider(create: (_) => MyLabReportsProvider()),
    ChangeNotifierProvider(create: (_) => DietLogProvider()),
    ChangeNotifierProvider(create: (_) => HealthCareConsultationProvider()),
    ChangeNotifierProvider(create: (_) => MedicalHistoryProvider()),
    ChangeNotifierProvider(create: (_) => SecondOpinionProvider()),
    ChangeNotifierProvider(create: (_) => LiveWellProvider()),
    ChangeNotifierProvider(create: (_) => ChallengesProvider()),
    ChangeNotifierProvider(create: (_) => GetCitiesProvider()),
    ChangeNotifierProvider(create: (_) => LabsProvider()),
    ChangeNotifierProvider(create: (_) => LifeStyleProviders()),
    ChangeNotifierProvider(create: (_) => DietPlansProvider()),
    ChangeNotifierProvider(create: (_) => AyurvedaProvider()),
    ChangeNotifierProvider(create: (_) => BlogsProvider()),
    ChangeNotifierProvider(create: (_) => HealthCarePlansProvider()),
    ChangeNotifierProvider(create: (_) => CalorieTrackerProvider()),
    ChangeNotifierProvider(create: (context) => AllConsultationsData()),
    ChangeNotifierProvider(create: (context) => StorePrescriptionProvider()),
    ChangeNotifierProvider(create: (context) => HeartRateTrackerProvider()),
    ChangeNotifierProvider(create: (context) => WomensSpecialProvider()),
    ChangeNotifierProvider(create: (context) => MedicationData()),
    ChangeNotifierProvider(create: (context) => PhysioTherapyPlansProvider()),
    ChangeNotifierProvider(create: (context) => FitnessPlansProvider()),
    ChangeNotifierProvider(create: (context) => ManageWeightPlansProvider()),
  ];
}

 //  [
      //   ChangeNotifierProvider(
      //     create: (ctx) => LoginData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => SignUpData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => UserData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => EnquiryData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => ExpertiseData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => PackagesData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => ExpertsData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => ConsultNowData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => SessionData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => HealthData(),
      //   ),
      //   ChangeNotifierProvider(
      //     create: (ctx) => SubscriptionsData(),
      //   )
      // ],
