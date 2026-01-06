wakati_app/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_constants.dart
│   │   │   ├── api_constants.dart
│   │   │   ├── storage_keys.dart
│   │   │   ├── route_constants.dart
│   │   │   └── asset_constants.dart
│   │   │
│   │   ├── config/
│   │   │   ├── app_config.dart
│   │   │   ├── environment.dart
│   │   │   └── flavor_config.dart
│   │   │
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   ├── app_text_styles.dart
│   │   │   ├── app_dimensions.dart
│   │   │   └── theme_provider.dart
│   │   │
│   │   ├── localization/
│   │   │   ├── app_localizations.dart
│   │   │   ├── language_provider.dart
│   │   │   └── translations/
│   │   │       ├── en.json
│   │   │       ├── yo.json (Yoruba)
│   │   │       ├── ig.json (Igbo)
│   │   │       ├── ha.json (Hausa)
│   │   │       └── fr.json (French)
│   │   │
│   │   ├── network/
│   │   │   ├── api_client.dart
│   │   │   ├── api_interceptor.dart
│   │   │   ├── network_info.dart
│   │   │   └── dio_client.dart
│   │   │
│   │   ├── error/
│   │   │   ├── exceptions.dart
│   │   │   ├── failures.dart
│   │   │   └── error_handler.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.dart
│   │   │   ├── date_time_utils.dart
│   │   │   ├── timezone_utils.dart
│   │   │   ├── formatters.dart
│   │   │   ├── permission_handler.dart
│   │   │   ├── logger.dart
│   │   │   └── device_info.dart
│   │   │
│   │   ├── extensions/
│   │   │   ├── string_extensions.dart
│   │   │   ├── datetime_extensions.dart
│   │   │   ├── context_extensions.dart
│   │   │   └── number_extensions.dart
│   │   │
│   │   └── services/
│   │       ├── local_storage_service.dart
│   │       ├── secure_storage_service.dart
│   │       ├── location_service.dart
│   │       ├── notification_service.dart
│   │       ├── biometric_service.dart
│   │       ├── connectivity_service.dart
│   │       └── analytics_service.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── company_model.dart
│   │   │   ├── employee_model.dart
│   │   │   ├── clock_entry_model.dart
│   │   │   ├── break_entry_model.dart
│   │   │   ├── leave_request_model.dart
│   │   │   ├── reminder_model.dart
│   │   │   ├── performance_model.dart
│   │   │   └── location_model.dart
│   │   │
│   │   ├── repositories/
│   │   │   ├── auth_repository.dart
│   │   │   ├── user_repository.dart
│   │   │   ├── company_repository.dart
│   │   │   ├── time_tracking_repository.dart
│   │   │   ├── leave_repository.dart
│   │   │   ├── reminder_repository.dart
│   │   │   ├── performance_repository.dart
│   │   │   └── admin_repository.dart
│   │   │
│   │   ├── data_sources/
│   │   │   ├── remote/
│   │   │   │   ├── auth_remote_data_source.dart
│   │   │   │   ├── user_remote_data_source.dart
│   │   │   │   ├── company_remote_data_source.dart
│   │   │   │   ├── time_tracking_remote_data_source.dart
│   │   │   │   ├── leave_remote_data_source.dart
│   │   │   │   ├── reminder_remote_data_source.dart
│   │   │   │   └── admin_remote_data_source.dart
│   │   │   │
│   │   │   └── local/
│   │   │       ├── auth_local_data_source.dart
│   │   │       ├── user_local_data_source.dart
│   │   │       ├── time_tracking_local_data_source.dart
│   │   │       ├── leave_local_data_source.dart
│   │   │       ├── reminder_local_data_source.dart
│   │   │       └── cache_manager.dart
│   │   │
│   │   └── database/
│   │       ├── app_database.dart
│   │       ├── dao/
│   │       │   ├── clock_entry_dao.dart
│   │       │   ├── break_entry_dao.dart
│   │       │   ├── leave_dao.dart
│   │       │   └── reminder_dao.dart
│   │       │
│   │       └── entities/
│   │           ├── clock_entry_entity.dart
│   │           ├── break_entry_entity.dart
│   │           ├── leave_entity.dart
│   │           └── reminder_entity.dart
│   │
│   ├── features/
│   │   ├── splash/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   └── splash_screen.dart
│   │   │   │   └── providers/
│   │   │   │       └── splash_provider.dart
│   │   │   └── splash_feature.dart
│   │   │
│   │   ├── onboarding/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── onboarding_screen.dart
│   │   │   │   │   └── language_selection_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── onboarding_page_widget.dart
│   │   │   │   │   └── language_card.dart
│   │   │   │   └── providers/
│   │   │   │       └── onboarding_provider.dart
│   │   │   └── onboarding_feature.dart
│   │   │
│   │   ├── auth/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── login_screen.dart
│   │   │   │   │   ├── register_screen.dart
│   │   │   │   │   ├── forgot_password_screen.dart
│   │   │   │   │   ├── company_registration_screen.dart
│   │   │   │   │   └── employee_onboarding_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── custom_text_field.dart
│   │   │   │   │   ├── social_login_button.dart
│   │   │   │   │   ├── auth_button.dart
│   │   │   │   │   └── biometric_login_button.dart
│   │   │   │   └── providers/
│   │   │   │       ├── auth_provider.dart
│   │   │   │       ├── login_provider.dart
│   │   │   │       ├── register_provider.dart
│   │   │   │       └── company_registration_provider.dart
│   │   │   └── auth_feature.dart
│   │   │
│   │   ├── home/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── home_screen.dart
│   │   │   │   │   └── main_navigation_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── clock_in_card.dart
│   │   │   │   │   ├── work_summary_card.dart
│   │   │   │   │   ├── quick_action_buttons.dart
│   │   │   │   │   ├── active_timer_widget.dart
│   │   │   │   │   └── location_status_widget.dart
│   │   │   │   └── providers/
│   │   │   │       └── home_provider.dart
│   │   │   └── home_feature.dart
│   │   │
│   │   ├── time_tracking/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── clock_in_out_screen.dart
│   │   │   │   │   ├── break_management_screen.dart
│   │   │   │   │   ├── time_history_screen.dart
│   │   │   │   │   └── time_details_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── clock_button.dart
│   │   │   │   │   ├── timer_display.dart
│   │   │   │   │   ├── break_timer.dart
│   │   │   │   │   ├── time_entry_card.dart
│   │   │   │   │   ├── filter_chips.dart
│   │   │   │   │   └── calendar_view.dart
│   │   │   │   └── providers/
│   │   │   │       ├── time_tracking_provider.dart
│   │   │   │       ├── break_provider.dart
│   │   │   │       └── time_history_provider.dart
│   │   │   └── time_tracking_feature.dart
│   │   │
│   │   ├── leave_management/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── leave_request_screen.dart
│   │   │   │   │   ├── leave_history_screen.dart
│   │   │   │   │   ├── leave_balance_screen.dart
│   │   │   │   │   └── leave_detail_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── leave_type_selector.dart
│   │   │   │   │   ├── date_range_picker.dart
│   │   │   │   │   ├── leave_request_card.dart
│   │   │   │   │   ├── leave_status_badge.dart
│   │   │   │   │   └── leave_balance_card.dart
│   │   │   │   └── providers/
│   │   │   │       ├── leave_request_provider.dart
│   │   │   │       └── leave_history_provider.dart
│   │   │   └── leave_management_feature.dart
│   │   │
│   │   ├── reminders/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── reminders_screen.dart
│   │   │   │   │   ├── create_reminder_screen.dart
│   │   │   │   │   └── reminder_settings_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── reminder_card.dart
│   │   │   │   │   ├── reminder_type_selector.dart
│   │   │   │   │   └── automated_reminder_toggle.dart
│   │   │   │   └── providers/
│   │   │   │       └── reminder_provider.dart
│   │   │   └── reminders_feature.dart
│   │   │
│   │   ├── performance/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── performance_dashboard_screen.dart
│   │   │   │   │   └── performance_details_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── performance_chart.dart
│   │   │   │   │   ├── achievement_badge.dart
│   │   │   │   │   ├── metric_card.dart
│   │   │   │   │   └── progress_indicator_widget.dart
│   │   │   │   └── providers/
│   │   │   │       └── performance_provider.dart
│   │   │   └── performance_feature.dart
│   │   │
│   │   ├── location/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── map_screen.dart
│   │   │   │   │   ├── location_history_screen.dart
│   │   │   │   │   └── update_location_status_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── live_map_widget.dart
│   │   │   │   │   ├── location_status_selector.dart
│   │   │   │   │   └── location_history_item.dart
│   │   │   │   └── providers/
│   │   │   │       ├── location_provider.dart
│   │   │   │       └── location_status_provider.dart
│   │   │   └── location_feature.dart
│   │   │
│   │   ├── ai_assistant/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── ai_chat_screen.dart
│   │   │   │   │   └── ai_insights_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── chat_message_bubble.dart
│   │   │   │   │   ├── ai_suggestion_card.dart
│   │   │   │   │   ├── voice_input_button.dart
│   │   │   │   │   └── insight_widget.dart
│   │   │   │   └── providers/
│   │   │   │       ├── ai_chat_provider.dart
│   │   │   │       └── ai_insights_provider.dart
│   │   │   └── ai_assistant_feature.dart
│   │   │
│   │   ├── profile/
│   │   │   ├── presentation/
│   │   │   │   ├── pages/
│   │   │   │   │   ├── profile_screen.dart
│   │   │   │   │   ├── edit_profile_screen.dart
│   │   │   │   │   └── settings_screen.dart
│   │   │   │   ├── widgets/
│   │   │   │   │   ├── profile_header.dart
│   │   │   │   │   ├── profile_info_card.dart
│   │   │   │   │   ├── settings_tile.dart
│   │   │   │   │   └── timezone_selector.dart
│   │   │   │   └── providers/
│   │   │   │       ├── profile_provider.dart
│   │   │   │       └── settings_provider.dart
│   │   │   └── profile_feature.dart
│   │   │
│   │   └── admin/
│   │       ├── presentation/
│   │       │   ├── pages/
│   │       │   │   ├── admin_dashboard_screen.dart
│   │       │   │   ├── employee_management_screen.dart
│   │       │   │   ├── add_edit_employee_screen.dart
│   │       │   │   ├── attendance_monitoring_screen.dart
│   │       │   │   ├── leave_approval_screen.dart
│   │       │   │   ├── reports_screen.dart
│   │       │   │   ├── company_settings_screen.dart
│   │       │   │   └── geofencing_setup_screen.dart
│   │       │   ├── widgets/
│   │       │   │   ├── admin_stat_card.dart
│   │       │   │   ├── employee_list_item.dart
│   │       │   │   ├── attendance_chart.dart
│   │       │   │   ├── leave_approval_card.dart
│   │       │   │   ├── report_filter.dart
│   │       │   │   └── bulk_import_widget.dart
│   │       │   └── providers/
│   │       │       ├── admin_dashboard_provider.dart
│   │       │       ├── employee_management_provider.dart
│   │       │       ├── attendance_monitoring_provider.dart
│   │       │       ├── leave_approval_provider.dart
│   │       │       └── reports_provider.dart
│   │       └── admin_feature.dart
│   │
│   ├── shared/
│   │   ├── widgets/
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_card.dart
│   │   │   ├── custom_dialog.dart
│   │   │   ├── custom_snackbar.dart
│   │   │   ├── loading_indicator.dart
│   │   │   ├── empty_state_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── search_bar_widget.dart
│   │   │   ├── filter_bottom_sheet.dart
│   │   │   ├── date_picker_widget.dart
│   │   │   ├── time_picker_widget.dart
│   │   │   └── offline_banner.dart
│   │   │
│   │   └── mixins/
│   │       ├── validation_mixin.dart
│   │       ├── loading_mixin.dart
│   │       └── error_handling_mixin.dart
│   │
│   └── routes/
│       ├── app_router.dart
│       ├── route_generator.dart
│       └── route_guards.dart
│
├── test/
│   ├── unit/
│   │   ├── core/
│   │   │   ├── utils/
│   │   │   └── services/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── data_sources/
│   │   └── features/
│   │       ├── auth/
│   │       ├── time_tracking/
│   │       └── leave_management/
│   │
│   ├── widget/
│   │   └── features/
│   │       ├── auth/
│   │       ├── home/
│   │       └── time_tracking/
│   │
│   ├── integration/
│   │   └── flows/
│   │       ├── clock_in_flow_test.dart
│   │       ├── leave_request_flow_test.dart
│   │       └── auth_flow_test.dart
│   │
│   └── mocks/
│       ├── mock_repositories.dart
│       ├── mock_services.dart
│       └── mock_data.dart
│
├── assets/
│   ├── images/
│   │   ├── logo/
│   │   ├── illustrations/
│   │   ├── icons/
│   │   └── placeholders/
│   ├── fonts/
│   ├── animations/
│   └── data/
│       └── countries.json
│
├── android/
├── ios/
├── web/
│
├── pubspec.yaml
├── analysis_options.yaml
├── README.md
└── .env.example