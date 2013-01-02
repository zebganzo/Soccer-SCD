pragma Ada_95;
pragma Source_File_Name (ada_main, Spec_File_Name => "b__soccer-main.ads");
pragma Source_File_Name (ada_main, Body_File_Name => "b__soccer-main.adb");

with System.Restrictions;
with Ada.Exceptions;

package body ada_main is
   pragma Warnings (Off);

   E013 : Short_Integer; pragma Import (Ada, E013, "system__soft_links_E");
   E221 : Short_Integer; pragma Import (Ada, E221, "system__fat_flt_E");
   E317 : Short_Integer; pragma Import (Ada, E317, "system__fat_lflt_E");
   E155 : Short_Integer; pragma Import (Ada, E155, "system__fat_llf_E");
   E023 : Short_Integer; pragma Import (Ada, E023, "system__exception_table_E");
   E167 : Short_Integer; pragma Import (Ada, E167, "ada__containers_E");
   E066 : Short_Integer; pragma Import (Ada, E066, "ada__io_exceptions_E");
   E215 : Short_Integer; pragma Import (Ada, E215, "ada__numerics_E");
   E104 : Short_Integer; pragma Import (Ada, E104, "ada__strings_E");
   E106 : Short_Integer; pragma Import (Ada, E106, "ada__strings__maps_E");
   E109 : Short_Integer; pragma Import (Ada, E109, "ada__strings__maps__constants_E");
   E006 : Short_Integer; pragma Import (Ada, E006, "ada__tags_E");
   E056 : Short_Integer; pragma Import (Ada, E056, "ada__streams_E");
   E068 : Short_Integer; pragma Import (Ada, E068, "interfaces__c_E");
   E070 : Short_Integer; pragma Import (Ada, E070, "interfaces__c__strings_E");
   E029 : Short_Integer; pragma Import (Ada, E029, "system__exceptions_E");
   E065 : Short_Integer; pragma Import (Ada, E065, "system__finalization_root_E");
   E063 : Short_Integer; pragma Import (Ada, E063, "ada__finalization_E");
   E346 : Short_Integer; pragma Import (Ada, E346, "system__regpat_E");
   E086 : Short_Integer; pragma Import (Ada, E086, "system__storage_pools_E");
   E078 : Short_Integer; pragma Import (Ada, E078, "system__finalization_masters_E");
   E092 : Short_Integer; pragma Import (Ada, E092, "system__storage_pools__subpools_E");
   E250 : Short_Integer; pragma Import (Ada, E250, "system__task_info_E");
   E210 : Short_Integer; pragma Import (Ada, E210, "ada__calendar_E");
   E208 : Short_Integer; pragma Import (Ada, E208, "ada__calendar__delays_E");
   E298 : Short_Integer; pragma Import (Ada, E298, "ada__calendar__time_zones_E");
   E339 : Short_Integer; pragma Import (Ada, E339, "gnat__calendar_E");
   E341 : Short_Integer; pragma Import (Ada, E341, "gnat__calendar__time_io_E");
   E437 : Short_Integer; pragma Import (Ada, E437, "gnat__secure_hashes_E");
   E439 : Short_Integer; pragma Import (Ada, E439, "gnat__secure_hashes__md5_E");
   E435 : Short_Integer; pragma Import (Ada, E435, "gnat__md5_E");
   E445 : Short_Integer; pragma Import (Ada, E445, "gnat__secure_hashes__sha1_E");
   E443 : Short_Integer; pragma Import (Ada, E443, "gnat__sha1_E");
   E088 : Short_Integer; pragma Import (Ada, E088, "system__pool_global_E");
   E388 : Short_Integer; pragma Import (Ada, E388, "gnat__sockets_E");
   E076 : Short_Integer; pragma Import (Ada, E076, "system__file_control_block_E");
   E176 : Short_Integer; pragma Import (Ada, E176, "ada__streams__stream_io_E");
   E540 : Short_Integer; pragma Import (Ada, E540, "system__direct_io_E");
   E061 : Short_Integer; pragma Import (Ada, E061, "system__file_io_E");
   E398 : Short_Integer; pragma Import (Ada, E398, "system__pool_size_E");
   E333 : Short_Integer; pragma Import (Ada, E333, "system__random_seed_E");
   E017 : Short_Integer; pragma Import (Ada, E017, "system__secondary_stack_E");
   E111 : Short_Integer; pragma Import (Ada, E111, "ada__strings__unbounded_E");
   E294 : Short_Integer; pragma Import (Ada, E294, "ada__directories_E");
   E396 : Short_Integer; pragma Import (Ada, E396, "gnat__sockets__thin_common_E");
   E073 : Short_Integer; pragma Import (Ada, E073, "system__os_lib_E");
   E391 : Short_Integer; pragma Import (Ada, E391, "gnat__sockets__thin_E");
   E302 : Short_Integer; pragma Import (Ada, E302, "system__regexp_E");
   E174 : Short_Integer; pragma Import (Ada, E174, "system__strings__stream_ops_E");
   E262 : Short_Integer; pragma Import (Ada, E262, "system__tasking__initialization_E");
   E268 : Short_Integer; pragma Import (Ada, E268, "system__tasking__protected_objects_E");
   E536 : Short_Integer; pragma Import (Ada, E536, "system__tasking__task_attributes_E");
   E282 : Short_Integer; pragma Import (Ada, E282, "ada__real_time_E");
   E055 : Short_Integer; pragma Import (Ada, E055, "ada__text_io_E");
   E270 : Short_Integer; pragma Import (Ada, E270, "system__tasking__protected_objects__entries_E");
   E274 : Short_Integer; pragma Import (Ada, E274, "system__tasking__queuing_E");
   E280 : Short_Integer; pragma Import (Ada, E280, "system__tasking__stages_E");
   E463 : Short_Integer; pragma Import (Ada, E463, "aws__containers__key_value_E");
   E462 : Short_Integer; pragma Import (Ada, E462, "aws__containers__key_value_E");
   E414 : Short_Integer; pragma Import (Ada, E414, "aws__containers__string_vectors_E");
   E413 : Short_Integer; pragma Import (Ada, E413, "aws__containers__string_vectors_E");
   E292 : Short_Integer; pragma Import (Ada, E292, "aws__config_E");
   E304 : Short_Integer; pragma Import (Ada, E304, "aws__config__ini_E");
   E417 : Short_Integer; pragma Import (Ada, E417, "aws__config__set_E");
   E308 : Short_Integer; pragma Import (Ada, E308, "aws__config__utils_E");
   E423 : Short_Integer; pragma Import (Ada, E423, "aws__containers__tables_E");
   E455 : Short_Integer; pragma Import (Ada, E455, "aws__containers__tables__set_E");
   E449 : Short_Integer; pragma Import (Ada, E449, "aws__digest_E");
   E426 : Short_Integer; pragma Import (Ada, E426, "aws__messages_E");
   E457 : Short_Integer; pragma Import (Ada, E457, "aws__mime_E");
   E459 : Short_Integer; pragma Import (Ada, E459, "aws__parameters_E");
   E467 : Short_Integer; pragma Import (Ada, E467, "aws__url_E");
   E469 : Short_Integer; pragma Import (Ada, E469, "aws__url__raise_url_error_E");
   E471 : Short_Integer; pragma Import (Ada, E471, "aws__url__set_E");
   E099 : Short_Integer; pragma Import (Ada, E099, "gnatcoll__json_E");
   E123 : Short_Integer; pragma Import (Ada, E123, "gnatcoll__json__utility_E");
   E368 : Short_Integer; pragma Import (Ada, E368, "memory_streams_E");
   E094 : Short_Integer; pragma Import (Ada, E094, "soccer_E");
   E179 : Short_Integer; pragma Import (Ada, E179, "soccer__core_event_E");
   E180 : Short_Integer; pragma Import (Ada, E180, "soccer__core_event__game_core_event_E");
   E182 : Short_Integer; pragma Import (Ada, E182, "soccer__core_event__game_core_event__binary_game_event_E");
   E186 : Short_Integer; pragma Import (Ada, E186, "soccer__core_event__game_core_event__match_game_event_E");
   E188 : Short_Integer; pragma Import (Ada, E188, "soccer__core_event__game_core_event__unary_game_event_E");
   E190 : Short_Integer; pragma Import (Ada, E190, "soccer__core_event__motion_core_event_E");
   E206 : Short_Integer; pragma Import (Ada, E206, "soccer__controllerpkg_E");
   E191 : Short_Integer; pragma Import (Ada, E191, "soccer__core_event__motion_core_event__catch_motion_event_E");
   E192 : Short_Integer; pragma Import (Ada, E192, "soccer__core_event__motion_core_event__move_motion_event_E");
   E194 : Short_Integer; pragma Import (Ada, E194, "soccer__core_event__motion_core_event__shot_motion_event_E");
   E196 : Short_Integer; pragma Import (Ada, E196, "soccer__core_event__motion_core_event__tackle_motion_event_E");
   E198 : Short_Integer; pragma Import (Ada, E198, "soccer__field_event_E");
   E200 : Short_Integer; pragma Import (Ada, E200, "soccer__manager_event_E");
   E202 : Short_Integer; pragma Import (Ada, E202, "soccer__manager_event__formation_E");
   E204 : Short_Integer; pragma Import (Ada, E204, "soccer__manager_event__substitution_E");
   E096 : Short_Integer; pragma Import (Ada, E096, "soccer__bridge_E");
   E286 : Short_Integer; pragma Import (Ada, E286, "soccer__playerspkg_E");
   E217 : Short_Integer; pragma Import (Ada, E217, "soccer__utils_E");
   E401 : Short_Integer; pragma Import (Ada, E401, "ssl__thin_E");
   E380 : Short_Integer; pragma Import (Ada, E380, "templates_parser_tasking_E");
   E335 : Short_Integer; pragma Import (Ada, E335, "templates_parser_E");
   E374 : Short_Integer; pragma Import (Ada, E374, "templates_parser__input_E");
   E376 : Short_Integer; pragma Import (Ada, E376, "templates_parser__utils_E");
   E359 : Short_Integer; pragma Import (Ada, E359, "zlib_E");
   E314 : Short_Integer; pragma Import (Ada, E314, "aws__utils_E");
   E310 : Short_Integer; pragma Import (Ada, E310, "aws__net_E");
   E421 : Short_Integer; pragma Import (Ada, E421, "aws__headers_E");
   E451 : Short_Integer; pragma Import (Ada, E451, "aws__attachments_E");
   E453 : Short_Integer; pragma Import (Ada, E453, "aws__headers__set_E");
   E428 : Short_Integer; pragma Import (Ada, E428, "aws__headers__values_E");
   E403 : Short_Integer; pragma Import (Ada, E403, "aws__net__buffered_E");
   E493 : Short_Integer; pragma Import (Ada, E493, "aws__net__generic_sets_E");
   E312 : Short_Integer; pragma Import (Ada, E312, "aws__net__log_E");
   E382 : Short_Integer; pragma Import (Ada, E382, "aws__net__poll_events_E");
   E386 : Short_Integer; pragma Import (Ada, E386, "aws__net__std_E");
   E384 : Short_Integer; pragma Import (Ada, E384, "aws__net__ssl_E");
   E505 : Short_Integer; pragma Import (Ada, E505, "aws__net__ssl__certificate_E");
   E507 : Short_Integer; pragma Import (Ada, E507, "aws__net__ssl__certificate__impl_E");
   E473 : Short_Integer; pragma Import (Ada, E473, "aws__parameters__set_E");
   E351 : Short_Integer; pragma Import (Ada, E351, "aws__resources_E");
   E370 : Short_Integer; pragma Import (Ada, E370, "aws__resources__files_E");
   E355 : Short_Integer; pragma Import (Ada, E355, "aws__resources__streams_E");
   E372 : Short_Integer; pragma Import (Ada, E372, "aws__resources__streams__disk_E");
   E481 : Short_Integer; pragma Import (Ada, E481, "aws__resources__streams__disk__once_E");
   E363 : Short_Integer; pragma Import (Ada, E363, "aws__resources__streams__memory_E");
   E353 : Short_Integer; pragma Import (Ada, E353, "aws__resources__embedded_E");
   E408 : Short_Integer; pragma Import (Ada, E408, "aws__resources__streams__memory__zlib_E");
   E357 : Short_Integer; pragma Import (Ada, E357, "aws__resources__streams__zlib_E");
   E523 : Short_Integer; pragma Import (Ada, E523, "aws__services__transient_pages_E");
   E527 : Short_Integer; pragma Import (Ada, E527, "aws__services__transient_pages__control_E");
   E406 : Short_Integer; pragma Import (Ada, E406, "aws__translator_E");
   E465 : Short_Integer; pragma Import (Ada, E465, "aws__utils__streams_E");
   E361 : Short_Integer; pragma Import (Ada, E361, "zlib__thin_E");
   E534 : Short_Integer; pragma Import (Ada, E534, "aws__net__acceptors_E");
   E461 : Short_Integer; pragma Import (Ada, E461, "aws__session_E");
   E529 : Short_Integer; pragma Import (Ada, E529, "aws__session__control_E");
   E447 : Short_Integer; pragma Import (Ada, E447, "aws__status_E");
   E419 : Short_Integer; pragma Import (Ada, E419, "aws__net__websocket_E");
   E431 : Short_Integer; pragma Import (Ada, E431, "aws__net__websocket__protocol__draft76_E");
   E441 : Short_Integer; pragma Import (Ada, E441, "aws__net__websocket__protocol__rfc6455_E");
   E491 : Short_Integer; pragma Import (Ada, E491, "aws__net__websocket__registry_E");
   E495 : Short_Integer; pragma Import (Ada, E495, "aws__net__websocket__registry__control_E");
   E509 : Short_Integer; pragma Import (Ada, E509, "aws__net__websocket__registry__watch_E");
   E479 : Short_Integer; pragma Import (Ada, E479, "aws__response_E");
   E501 : Short_Integer; pragma Import (Ada, E501, "aws__client_E");
   E503 : Short_Integer; pragma Import (Ada, E503, "aws__client__http_utils_E");
   E477 : Short_Integer; pragma Import (Ada, E477, "aws__dispatchers_E");
   E485 : Short_Integer; pragma Import (Ada, E485, "aws__dispatchers__callback_E");
   E499 : Short_Integer; pragma Import (Ada, E499, "aws__hotplug_E");
   E515 : Short_Integer; pragma Import (Ada, E515, "aws__hotplug__get_status_E");
   E487 : Short_Integer; pragma Import (Ada, E487, "aws__log_E");
   E483 : Short_Integer; pragma Import (Ada, E483, "aws__response__set_E");
   E475 : Short_Integer; pragma Import (Ada, E475, "aws__server_E");
   E511 : Short_Integer; pragma Import (Ada, E511, "aws__server__get_status_E");
   E497 : Short_Integer; pragma Import (Ada, E497, "aws__server__http_utils_E");
   E517 : Short_Integer; pragma Import (Ada, E517, "aws__server__log_E");
   E513 : Short_Integer; pragma Import (Ada, E513, "aws__server__status_E");
   E520 : Short_Integer; pragma Import (Ada, E520, "aws__status__set_E");
   E531 : Short_Integer; pragma Import (Ada, E531, "aws__status__translate_set_E");
   E538 : Short_Integer; pragma Import (Ada, E538, "soccer__server__callbacks_E");
   E542 : Short_Integer; pragma Import (Ada, E542, "soccer__server__websockets_E");
   E289 : Short_Integer; pragma Import (Ada, E289, "soccer__server__webserver_E");

   Local_Priority_Specific_Dispatching : constant String := "";
   Local_Interrupt_States : constant String := "";

   Is_Elaborated : Boolean := False;

   procedure finalize_library is
   begin
      E289 := E289 - 1;
      declare
         procedure F1;
         pragma Import (Ada, F1, "soccer__server__webserver__finalize_spec");
      begin
         F1;
      end;
      E542 := E542 - 1;
      declare
         procedure F2;
         pragma Import (Ada, F2, "soccer__server__websockets__finalize_spec");
      begin
         F2;
      end;
      declare
         procedure F3;
         pragma Import (Ada, F3, "aws__server__finalize_body");
      begin
         E475 := E475 - 1;
         F3;
      end;
      declare
         procedure F4;
         pragma Import (Ada, F4, "aws__server__finalize_spec");
      begin
         F4;
      end;
      E479 := E479 - 1;
      E487 := E487 - 1;
      declare
         procedure F5;
         pragma Import (Ada, F5, "aws__log__finalize_spec");
      begin
         F5;
      end;
      E499 := E499 - 1;
      declare
         procedure F6;
         pragma Import (Ada, F6, "aws__hotplug__finalize_spec");
      begin
         F6;
      end;
      E485 := E485 - 1;
      declare
         procedure F7;
         pragma Import (Ada, F7, "aws__dispatchers__callback__finalize_spec");
      begin
         F7;
      end;
      E477 := E477 - 1;
      declare
         procedure F8;
         pragma Import (Ada, F8, "aws__dispatchers__finalize_spec");
      begin
         F8;
      end;
      E501 := E501 - 1;
      declare
         procedure F9;
         pragma Import (Ada, F9, "aws__client__finalize_spec");
      begin
         F9;
      end;
      declare
         procedure F10;
         pragma Import (Ada, F10, "aws__response__finalize_spec");
      begin
         F10;
      end;
      declare
         procedure F11;
         pragma Import (Ada, F11, "aws__net__websocket__registry__finalize_body");
      begin
         E491 := E491 - 1;
         F11;
      end;
      E419 := E419 - 1;
      declare
         procedure F12;
         pragma Import (Ada, F12, "aws__net__websocket__finalize_spec");
      begin
         F12;
      end;
      declare
         procedure F13;
         pragma Import (Ada, F13, "aws__session__finalize_body");
      begin
         E461 := E461 - 1;
         F13;
      end;
      declare
         procedure F14;
         pragma Import (Ada, F14, "aws__session__finalize_spec");
      begin
         F14;
      end;
      E534 := E534 - 1;
      declare
         procedure F15;
         pragma Import (Ada, F15, "aws__net__acceptors__finalize_spec");
      begin
         F15;
      end;
      declare
         procedure F16;
         pragma Import (Ada, F16, "aws__mime__finalize_body");
      begin
         E457 := E457 - 1;
         F16;
      end;
      E359 := E359 - 1;
      declare
         procedure F17;
         pragma Import (Ada, F17, "templates_parser__finalize_body");
      begin
         E335 := E335 - 1;
         F17;
      end;
      E465 := E465 - 1;
      declare
         procedure F18;
         pragma Import (Ada, F18, "aws__utils__streams__finalize_spec");
      begin
         F18;
      end;
      declare
         procedure F19;
         pragma Import (Ada, F19, "aws__attachments__finalize_body");
      begin
         E451 := E451 - 1;
         F19;
      end;
      declare
         procedure F20;
         pragma Import (Ada, F20, "aws__services__transient_pages__finalize_body");
      begin
         E523 := E523 - 1;
         F20;
      end;
      declare
         procedure F21;
         pragma Import (Ada, F21, "aws__services__transient_pages__finalize_spec");
      begin
         F21;
      end;
      declare
         procedure F22;
         pragma Import (Ada, F22, "aws__resources__embedded__finalize_body");
      begin
         E353 := E353 - 1;
         F22;
      end;
      E357 := E357 - 1;
      declare
         procedure F23;
         pragma Import (Ada, F23, "aws__resources__streams__zlib__finalize_spec");
      begin
         F23;
      end;
      E408 := E408 - 1;
      declare
         procedure F24;
         pragma Import (Ada, F24, "aws__resources__streams__memory__zlib__finalize_spec");
      begin
         F24;
      end;
      E363 := E363 - 1;
      declare
         procedure F25;
         pragma Import (Ada, F25, "aws__resources__streams__memory__finalize_spec");
      begin
         F25;
      end;
      E481 := E481 - 1;
      declare
         procedure F26;
         pragma Import (Ada, F26, "aws__resources__streams__disk__once__finalize_spec");
      begin
         F26;
      end;
      E372 := E372 - 1;
      declare
         procedure F27;
         pragma Import (Ada, F27, "aws__resources__streams__disk__finalize_spec");
      begin
         F27;
      end;
      E355 := E355 - 1;
      declare
         procedure F28;
         pragma Import (Ada, F28, "aws__resources__streams__finalize_spec");
      begin
         F28;
      end;
      E310 := E310 - 1;
      E384 := E384 - 1;
      declare
         procedure F29;
         pragma Import (Ada, F29, "aws__net__ssl__finalize_spec");
      begin
         F29;
      end;
      E386 := E386 - 1;
      declare
         procedure F30;
         pragma Import (Ada, F30, "aws__net__std__finalize_spec");
      begin
         F30;
      end;
      E382 := E382 - 1;
      declare
         procedure F31;
         pragma Import (Ada, F31, "aws__net__poll_events__finalize_spec");
      begin
         F31;
      end;
      declare
         procedure F32;
         pragma Import (Ada, F32, "aws__net__log__finalize_body");
      begin
         E312 := E312 - 1;
         F32;
      end;
      E421 := E421 - 1;
      E426 := E426 - 1;
      declare
         procedure F33;
         pragma Import (Ada, F33, "aws__attachments__finalize_spec");
      begin
         F33;
      end;
      declare
         procedure F34;
         pragma Import (Ada, F34, "aws__headers__finalize_spec");
      begin
         F34;
      end;
      declare
         procedure F35;
         pragma Import (Ada, F35, "aws__net__finalize_spec");
      begin
         F35;
      end;
      E314 := E314 - 1;
      declare
         procedure F36;
         pragma Import (Ada, F36, "aws__utils__finalize_spec");
      begin
         F36;
      end;
      declare
         procedure F37;
         pragma Import (Ada, F37, "zlib__finalize_spec");
      begin
         F37;
      end;
      declare
         procedure F38;
         pragma Import (Ada, F38, "templates_parser__finalize_spec");
      begin
         F38;
      end;
      declare
         procedure F39;
         pragma Import (Ada, F39, "templates_parser_tasking__finalize_body");
      begin
         E380 := E380 - 1;
         F39;
      end;
      E206 := E206 - 1;
      E204 := E204 - 1;
      declare
         procedure F40;
         pragma Import (Ada, F40, "soccer__manager_event__substitution__finalize_spec");
      begin
         F40;
      end;
      E202 := E202 - 1;
      declare
         procedure F41;
         pragma Import (Ada, F41, "soccer__manager_event__formation__finalize_spec");
      begin
         F41;
      end;
      E200 := E200 - 1;
      declare
         procedure F42;
         pragma Import (Ada, F42, "soccer__manager_event__finalize_spec");
      begin
         F42;
      end;
      E196 := E196 - 1;
      declare
         procedure F43;
         pragma Import (Ada, F43, "soccer__core_event__motion_core_event__tackle_motion_event__finalize_spec");
      begin
         F43;
      end;
      E194 := E194 - 1;
      declare
         procedure F44;
         pragma Import (Ada, F44, "soccer__core_event__motion_core_event__shot_motion_event__finalize_spec");
      begin
         F44;
      end;
      declare
         procedure F45;
         pragma Import (Ada, F45, "soccer__core_event__motion_core_event__move_motion_event__finalize_spec");
      begin
         E192 := E192 - 1;
         F45;
      end;
      declare
         procedure F46;
         pragma Import (Ada, F46, "soccer__core_event__motion_core_event__catch_motion_event__finalize_spec");
      begin
         E191 := E191 - 1;
         F46;
      end;
      declare
         procedure F47;
         pragma Import (Ada, F47, "soccer__controllerpkg__finalize_spec");
      begin
         F47;
      end;
      E190 := E190 - 1;
      declare
         procedure F48;
         pragma Import (Ada, F48, "soccer__core_event__motion_core_event__finalize_spec");
      begin
         F48;
      end;
      E188 := E188 - 1;
      declare
         procedure F49;
         pragma Import (Ada, F49, "soccer__core_event__game_core_event__unary_game_event__finalize_spec");
      begin
         F49;
      end;
      E186 := E186 - 1;
      declare
         procedure F50;
         pragma Import (Ada, F50, "soccer__core_event__game_core_event__match_game_event__finalize_spec");
      begin
         F50;
      end;
      E182 := E182 - 1;
      declare
         procedure F51;
         pragma Import (Ada, F51, "soccer__core_event__game_core_event__binary_game_event__finalize_spec");
      begin
         F51;
      end;
      declare
         procedure F52;
         pragma Import (Ada, F52, "soccer__core_event__finalize_spec");
      begin
         E179 := E179 - 1;
         F52;
      end;
      E099 := E099 - 1;
      declare
         procedure F53;
         pragma Import (Ada, F53, "gnatcoll__json__finalize_spec");
      begin
         F53;
      end;
      E459 := E459 - 1;
      declare
         procedure F54;
         pragma Import (Ada, F54, "aws__parameters__finalize_spec");
      begin
         F54;
      end;
      declare
         procedure F55;
         pragma Import (Ada, F55, "aws__messages__finalize_spec");
      begin
         F55;
      end;
      E423 := E423 - 1;
      declare
         procedure F56;
         pragma Import (Ada, F56, "aws__containers__tables__finalize_spec");
      begin
         F56;
      end;
      declare
         procedure F57;
         pragma Import (Ada, F57, "aws__config__finalize_body");
      begin
         E292 := E292 - 1;
         F57;
      end;
      declare
         procedure F58;
         pragma Import (Ada, F58, "aws__config__finalize_spec");
      begin
         F58;
      end;
      E270 := E270 - 1;
      declare
         procedure F59;
         pragma Import (Ada, F59, "system__tasking__protected_objects__entries__finalize_spec");
      begin
         F59;
      end;
      E055 := E055 - 1;
      declare
         procedure F60;
         pragma Import (Ada, F60, "ada__text_io__finalize_spec");
      begin
         F60;
      end;
      E536 := E536 - 1;
      declare
         procedure F61;
         pragma Import (Ada, F61, "system__tasking__task_attributes__finalize_spec");
      begin
         F61;
      end;
      declare
         procedure F62;
         pragma Import (Ada, F62, "gnat__sockets__finalize_body");
      begin
         E388 := E388 - 1;
         F62;
      end;
      E294 := E294 - 1;
      E302 := E302 - 1;
      declare
         procedure F63;
         pragma Import (Ada, F63, "system__regexp__finalize_spec");
      begin
         F63;
      end;
      declare
         procedure F64;
         pragma Import (Ada, F64, "system__file_io__finalize_body");
      begin
         E061 := E061 - 1;
         F64;
      end;
      declare
         procedure F65;
         pragma Import (Ada, F65, "ada__directories__finalize_spec");
      begin
         F65;
      end;
      E111 := E111 - 1;
      declare
         procedure F66;
         pragma Import (Ada, F66, "ada__strings__unbounded__finalize_spec");
      begin
         F66;
      end;
      E078 := E078 - 1;
      E092 := E092 - 1;
      E398 := E398 - 1;
      declare
         procedure F67;
         pragma Import (Ada, F67, "system__pool_size__finalize_spec");
      begin
         F67;
      end;
      E176 := E176 - 1;
      E540 := E540 - 1;
      declare
         procedure F68;
         pragma Import (Ada, F68, "system__direct_io__finalize_spec");
      begin
         F68;
      end;
      declare
         procedure F69;
         pragma Import (Ada, F69, "ada__streams__stream_io__finalize_spec");
      begin
         F69;
      end;
      declare
         procedure F70;
         pragma Import (Ada, F70, "system__file_control_block__finalize_spec");
      begin
         E076 := E076 - 1;
         F70;
      end;
      declare
         procedure F71;
         pragma Import (Ada, F71, "gnat__sockets__finalize_spec");
      begin
         F71;
      end;
      E088 := E088 - 1;
      declare
         procedure F72;
         pragma Import (Ada, F72, "system__pool_global__finalize_spec");
      begin
         F72;
      end;
      declare
         procedure F73;
         pragma Import (Ada, F73, "system__storage_pools__subpools__finalize_spec");
      begin
         F73;
      end;
      declare
         procedure F74;
         pragma Import (Ada, F74, "system__finalization_masters__finalize_spec");
      begin
         F74;
      end;
      declare
         procedure Reraise_Library_Exception_If_Any;
            pragma Import (Ada, Reraise_Library_Exception_If_Any, "__gnat_reraise_library_exception_if_any");
      begin
         Reraise_Library_Exception_If_Any;
      end;
   end finalize_library;

   procedure adafinal is
      procedure s_stalib_adafinal;
      pragma Import (C, s_stalib_adafinal, "system__standard_library__adafinal");
   begin
      if not Is_Elaborated then
         return;
      end if;
      Is_Elaborated := False;
      s_stalib_adafinal;
   end adafinal;

   type No_Param_Proc is access procedure;

   procedure adainit is
      Main_Priority : Integer;
      pragma Import (C, Main_Priority, "__gl_main_priority");
      Time_Slice_Value : Integer;
      pragma Import (C, Time_Slice_Value, "__gl_time_slice_val");
      WC_Encoding : Character;
      pragma Import (C, WC_Encoding, "__gl_wc_encoding");
      Locking_Policy : Character;
      pragma Import (C, Locking_Policy, "__gl_locking_policy");
      Queuing_Policy : Character;
      pragma Import (C, Queuing_Policy, "__gl_queuing_policy");
      Task_Dispatching_Policy : Character;
      pragma Import (C, Task_Dispatching_Policy, "__gl_task_dispatching_policy");
      Priority_Specific_Dispatching : System.Address;
      pragma Import (C, Priority_Specific_Dispatching, "__gl_priority_specific_dispatching");
      Num_Specific_Dispatching : Integer;
      pragma Import (C, Num_Specific_Dispatching, "__gl_num_specific_dispatching");
      Main_CPU : Integer;
      pragma Import (C, Main_CPU, "__gl_main_cpu");
      Interrupt_States : System.Address;
      pragma Import (C, Interrupt_States, "__gl_interrupt_states");
      Num_Interrupt_States : Integer;
      pragma Import (C, Num_Interrupt_States, "__gl_num_interrupt_states");
      Unreserve_All_Interrupts : Integer;
      pragma Import (C, Unreserve_All_Interrupts, "__gl_unreserve_all_interrupts");
      Zero_Cost_Exceptions : Integer;
      pragma Import (C, Zero_Cost_Exceptions, "__gl_zero_cost_exceptions");
      Detect_Blocking : Integer;
      pragma Import (C, Detect_Blocking, "__gl_detect_blocking");
      Default_Stack_Size : Integer;
      pragma Import (C, Default_Stack_Size, "__gl_default_stack_size");
      Leap_Seconds_Support : Integer;
      pragma Import (C, Leap_Seconds_Support, "__gl_leap_seconds_support");

      procedure Install_Handler;
      pragma Import (C, Install_Handler, "__gnat_install_handler");

      Handler_Installed : Integer;
      pragma Import (C, Handler_Installed, "__gnat_handler_installed");

      Finalize_Library_Objects : No_Param_Proc;
      pragma Import (C, Finalize_Library_Objects, "__gnat_finalize_library_objects");
   begin
      if Is_Elaborated then
         return;
      end if;
      Is_Elaborated := True;
      Main_Priority := -1;
      Time_Slice_Value := -1;
      WC_Encoding := 'b';
      Locking_Policy := ' ';
      Queuing_Policy := ' ';
      Task_Dispatching_Policy := ' ';
      System.Restrictions.Run_Time_Restrictions :=
        (Set =>
          (False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, False, False, False, False, False, 
           False, False, False, True, False, False, False, False, 
           False, False, False, False, False, False),
         Value => (0, 0, 0, 0, 0, 0, 0),
         Violated =>
          (True, False, True, True, True, False, False, True, 
           False, True, True, True, True, False, False, True, 
           False, False, True, True, False, True, True, True, 
           True, True, True, False, True, True, False, True, 
           False, True, True, True, True, True, False, True, 
           True, True, True, False, True, False, True, True, 
           True, True, False, True, True, True, True, True, 
           False, True, True, False, False, True, False, True, 
           True, False, True, True, True, False, True, True, 
           True, True, True, False, True, False),
         Count => (6, 3, 2, 7, 0, 15, 0),
         Unknown => (False, False, True, True, False, True, False));
      Priority_Specific_Dispatching :=
        Local_Priority_Specific_Dispatching'Address;
      Num_Specific_Dispatching := 0;
      Main_CPU := -1;
      Interrupt_States := Local_Interrupt_States'Address;
      Num_Interrupt_States := 0;
      Unreserve_All_Interrupts := 0;
      Zero_Cost_Exceptions := 1;
      Detect_Blocking := 0;
      Default_Stack_Size := -1;
      Leap_Seconds_Support := 0;

      if Handler_Installed = 0 then
         Install_Handler;
      end if;

      Finalize_Library_Objects := finalize_library'access;

      System.Soft_Links'Elab_Spec;
      System.Fat_Flt'Elab_Spec;
      E221 := E221 + 1;
      System.Fat_Lflt'Elab_Spec;
      E317 := E317 + 1;
      System.Fat_Llf'Elab_Spec;
      E155 := E155 + 1;
      System.Exception_Table'Elab_Body;
      E023 := E023 + 1;
      Ada.Containers'Elab_Spec;
      E167 := E167 + 1;
      Ada.Io_Exceptions'Elab_Spec;
      E066 := E066 + 1;
      Ada.Numerics'Elab_Spec;
      E215 := E215 + 1;
      Ada.Strings'Elab_Spec;
      E104 := E104 + 1;
      Ada.Strings.Maps'Elab_Spec;
      Ada.Strings.Maps.Constants'Elab_Spec;
      E109 := E109 + 1;
      Ada.Tags'Elab_Spec;
      Ada.Streams'Elab_Spec;
      E056 := E056 + 1;
      Interfaces.C'Elab_Spec;
      Interfaces.C.Strings'Elab_Spec;
      System.Exceptions'Elab_Spec;
      E029 := E029 + 1;
      System.Finalization_Root'Elab_Spec;
      E065 := E065 + 1;
      Ada.Finalization'Elab_Spec;
      E063 := E063 + 1;
      System.Regpat'Elab_Spec;
      System.Storage_Pools'Elab_Spec;
      E086 := E086 + 1;
      System.Finalization_Masters'Elab_Spec;
      System.Storage_Pools.Subpools'Elab_Spec;
      System.Task_Info'Elab_Spec;
      E250 := E250 + 1;
      Ada.Calendar'Elab_Spec;
      Ada.Calendar'Elab_Body;
      E210 := E210 + 1;
      Ada.Calendar.Delays'Elab_Body;
      E208 := E208 + 1;
      Ada.Calendar.Time_Zones'Elab_Spec;
      E298 := E298 + 1;
      Gnat.Calendar'Elab_Spec;
      E339 := E339 + 1;
      Gnat.Calendar.Time_Io'Elab_Spec;
      E437 := E437 + 1;
      Gnat.Secure_Hashes.Md5'Elab_Spec;
      E439 := E439 + 1;
      Gnat.Md5'Elab_Spec;
      E435 := E435 + 1;
      Gnat.Secure_Hashes.Sha1'Elab_Spec;
      E445 := E445 + 1;
      Gnat.Sha1'Elab_Spec;
      E443 := E443 + 1;
      System.Pool_Global'Elab_Spec;
      E088 := E088 + 1;
      Gnat.Sockets'Elab_Spec;
      System.File_Control_Block'Elab_Spec;
      E076 := E076 + 1;
      Ada.Streams.Stream_Io'Elab_Spec;
      System.Direct_Io'Elab_Spec;
      E540 := E540 + 1;
      E176 := E176 + 1;
      System.Pool_Size'Elab_Spec;
      E398 := E398 + 1;
      System.Random_Seed'Elab_Body;
      E333 := E333 + 1;
      E092 := E092 + 1;
      System.Finalization_Masters'Elab_Body;
      E078 := E078 + 1;
      E346 := E346 + 1;
      E070 := E070 + 1;
      E068 := E068 + 1;
      Ada.Tags'Elab_Body;
      E006 := E006 + 1;
      E106 := E106 + 1;
      System.Soft_Links'Elab_Body;
      E013 := E013 + 1;
      System.Secondary_Stack'Elab_Body;
      E017 := E017 + 1;
      Ada.Strings.Unbounded'Elab_Spec;
      E111 := E111 + 1;
      Ada.Directories'Elab_Spec;
      Gnat.Sockets.Thin_Common'Elab_Spec;
      E396 := E396 + 1;
      System.Os_Lib'Elab_Body;
      E073 := E073 + 1;
      System.File_Io'Elab_Body;
      E061 := E061 + 1;
      System.Regexp'Elab_Spec;
      E302 := E302 + 1;
      Ada.Directories'Elab_Body;
      E294 := E294 + 1;
      System.Strings.Stream_Ops'Elab_Body;
      E174 := E174 + 1;
      Gnat.Sockets'Elab_Body;
      E388 := E388 + 1;
      Gnat.Sockets.Thin'Elab_Body;
      E391 := E391 + 1;
      System.Tasking.Initialization'Elab_Body;
      E262 := E262 + 1;
      System.Tasking.Protected_Objects'Elab_Body;
      E268 := E268 + 1;
      System.Tasking.Task_Attributes'Elab_Spec;
      E536 := E536 + 1;
      Ada.Real_Time'Elab_Spec;
      Ada.Real_Time'Elab_Body;
      E282 := E282 + 1;
      Ada.Text_Io'Elab_Spec;
      Ada.Text_Io'Elab_Body;
      E055 := E055 + 1;
      E341 := E341 + 1;
      System.Tasking.Protected_Objects.Entries'Elab_Spec;
      E270 := E270 + 1;
      System.Tasking.Queuing'Elab_Body;
      E274 := E274 + 1;
      System.Tasking.Stages'Elab_Body;
      E280 := E280 + 1;
      AWS.CONTAINERS.KEY_VALUE'ELAB_SPEC;
      AWS.CONTAINERS.KEY_VALUE'ELAB_BODY;
      E463 := E463 + 1;
      AWS.CONTAINERS.STRING_VECTORS'ELAB_SPEC;
      AWS.CONTAINERS.STRING_VECTORS'ELAB_BODY;
      E414 := E414 + 1;
      AWS.CONFIG'ELAB_SPEC;
      AWS.CONFIG'ELAB_BODY;
      E292 := E292 + 1;
      AWS.CONTAINERS.TABLES'ELAB_SPEC;
      E423 := E423 + 1;
      E455 := E455 + 1;
      AWS.MESSAGES'ELAB_SPEC;
      AWS.PARAMETERS'ELAB_SPEC;
      E459 := E459 + 1;
      AWS.URL'ELAB_SPEC;
      E469 := E469 + 1;
      GNATCOLL.JSON'ELAB_SPEC;
      E123 := E123 + 1;
      E099 := E099 + 1;
      E368 := E368 + 1;
      Soccer'Elab_Spec;
      E094 := E094 + 1;
      Soccer.Core_Event'Elab_Spec;
      E179 := E179 + 1;
      Soccer.Core_Event.Game_Core_Event'Elab_Spec;
      E180 := E180 + 1;
      Soccer.Core_Event.Game_Core_Event.Binary_Game_Event'Elab_Spec;
      E182 := E182 + 1;
      Soccer.Core_Event.Game_Core_Event.Match_Game_Event'Elab_Spec;
      E186 := E186 + 1;
      Soccer.Core_Event.Game_Core_Event.Unary_Game_Event'Elab_Spec;
      E188 := E188 + 1;
      Soccer.Core_Event.Motion_Core_Event'Elab_Spec;
      E190 := E190 + 1;
      Soccer.Controllerpkg'Elab_Spec;
      Soccer.Core_Event.Motion_Core_Event.Catch_Motion_Event'Elab_Spec;
      E191 := E191 + 1;
      Soccer.Core_Event.Motion_Core_Event.Move_Motion_Event'Elab_Spec;
      E192 := E192 + 1;
      Soccer.Core_Event.Motion_Core_Event.Shot_Motion_Event'Elab_Spec;
      E194 := E194 + 1;
      Soccer.Core_Event.Motion_Core_Event.Tackle_Motion_Event'Elab_Spec;
      E196 := E196 + 1;
      E198 := E198 + 1;
      Soccer.Manager_Event'Elab_Spec;
      E200 := E200 + 1;
      Soccer.Manager_Event.Formation'Elab_Spec;
      E202 := E202 + 1;
      Soccer.Manager_Event.Substitution'Elab_Spec;
      E204 := E204 + 1;
      E096 := E096 + 1;
      Soccer.Utils'Elab_Body;
      E217 := E217 + 1;
      Soccer.Playerspkg'Elab_Body;
      E286 := E286 + 1;
      Soccer.Controllerpkg'Elab_Body;
      E206 := E206 + 1;
      SSL.THIN'ELAB_SPEC;
      E401 := E401 + 1;
      Templates_Parser_Tasking'Elab_Body;
      E380 := E380 + 1;
      Templates_Parser'Elab_Spec;
      Templates_Parser.Input'Elab_Spec;
      Templates_Parser.Utils'Elab_Spec;
      E376 := E376 + 1;
      Zlib'Elab_Spec;
      AWS.UTILS'ELAB_SPEC;
      AWS.UTILS'ELAB_BODY;
      E314 := E314 + 1;
      E417 := E417 + 1;
      E304 := E304 + 1;
      AWS.NET'ELAB_SPEC;
      AWS.HEADERS'ELAB_SPEC;
      AWS.ATTACHMENTS'ELAB_SPEC;
      E428 := E428 + 1;
      E426 := E426 + 1;
      AWS.NET.BUFFERED'ELAB_SPEC;
      AWS.HEADERS.SET'ELAB_BODY;
      E453 := E453 + 1;
      E421 := E421 + 1;
      E308 := E308 + 1;
      E493 := E493 + 1;
      AWS.NET.LOG'ELAB_BODY;
      E312 := E312 + 1;
      AWS.NET.POLL_EVENTS'ELAB_SPEC;
      E382 := E382 + 1;
      AWS.NET.STD'ELAB_SPEC;
      E386 := E386 + 1;
      AWS.NET.SSL'ELAB_SPEC;
      E384 := E384 + 1;
      E310 := E310 + 1;
      AWS.NET.SSL.CERTIFICATE'ELAB_SPEC;
      E507 := E507 + 1;
      E505 := E505 + 1;
      AWS.PARAMETERS.SET'ELAB_SPEC;
      E471 := E471 + 1;
      AWS.RESOURCES'ELAB_SPEC;
      E374 := E374 + 1;
      AWS.RESOURCES.STREAMS'ELAB_SPEC;
      E355 := E355 + 1;
      AWS.RESOURCES.STREAMS.DISK'ELAB_SPEC;
      E372 := E372 + 1;
      AWS.RESOURCES.STREAMS.DISK.ONCE'ELAB_SPEC;
      E481 := E481 + 1;
      AWS.RESOURCES.STREAMS.MEMORY'ELAB_SPEC;
      E363 := E363 + 1;
      E351 := E351 + 1;
      AWS.RESOURCES.STREAMS.MEMORY.ZLIB'ELAB_SPEC;
      E408 := E408 + 1;
      AWS.RESOURCES.STREAMS.ZLIB'ELAB_SPEC;
      E357 := E357 + 1;
      AWS.RESOURCES.EMBEDDED'ELAB_BODY;
      E353 := E353 + 1;
      E370 := E370 + 1;
      AWS.SERVICES.TRANSIENT_PAGES'ELAB_SPEC;
      AWS.SERVICES.TRANSIENT_PAGES'ELAB_BODY;
      E523 := E523 + 1;
      E527 := E527 + 1;
      AWS.TRANSLATOR'ELAB_BODY;
      E406 := E406 + 1;
      AWS.ATTACHMENTS'ELAB_BODY;
      E451 := E451 + 1;
      AWS.UTILS.STREAMS'ELAB_SPEC;
      E465 := E465 + 1;
      Templates_Parser'Elab_Body;
      E335 := E335 + 1;
      Zlib.Thin'Elab_Body;
      E361 := E361 + 1;
      E359 := E359 + 1;
      AWS.NET.BUFFERED'ELAB_BODY;
      E403 := E403 + 1;
      AWS.URL'ELAB_BODY;
      E467 := E467 + 1;
      AWS.MIME'ELAB_BODY;
      E457 := E457 + 1;
      AWS.DIGEST'ELAB_BODY;
      E449 := E449 + 1;
      AWS.NET.ACCEPTORS'ELAB_SPEC;
      E534 := E534 + 1;
      AWS.SESSION'ELAB_SPEC;
      AWS.SESSION'ELAB_BODY;
      E461 := E461 + 1;
      E529 := E529 + 1;
      E447 := E447 + 1;
      AWS.NET.WEBSOCKET'ELAB_SPEC;
      E431 := E431 + 1;
      E441 := E441 + 1;
      E419 := E419 + 1;
      AWS.NET.WEBSOCKET.REGISTRY'ELAB_BODY;
      E491 := E491 + 1;
      E495 := E495 + 1;
      E509 := E509 + 1;
      AWS.RESPONSE'ELAB_SPEC;
      AWS.CLIENT'ELAB_SPEC;
      E501 := E501 + 1;
      AWS.DISPATCHERS'ELAB_SPEC;
      E477 := E477 + 1;
      AWS.DISPATCHERS.CALLBACK'ELAB_SPEC;
      E485 := E485 + 1;
      AWS.HOTPLUG'ELAB_SPEC;
      E499 := E499 + 1;
      E515 := E515 + 1;
      AWS.LOG'ELAB_SPEC;
      E487 := E487 + 1;
      E483 := E483 + 1;
      E503 := E503 + 1;
      E479 := E479 + 1;
      AWS.SERVER'ELAB_SPEC;
      E473 := E473 + 1;
      E517 := E517 + 1;
      E513 := E513 + 1;
      E511 := E511 + 1;
      E520 := E520 + 1;
      AWS.SERVER.HTTP_UTILS'ELAB_BODY;
      E497 := E497 + 1;
      E531 := E531 + 1;
      AWS.SERVER'ELAB_BODY;
      E475 := E475 + 1;
      E538 := E538 + 1;
      Soccer.Server.Websockets'Elab_Spec;
      E542 := E542 + 1;
      Soccer.Server.Webserver'Elab_Spec;
      E289 := E289 + 1;
   end adainit;

   procedure Ada_Main_Program;
   pragma Import (Ada, Ada_Main_Program, "_ada_soccer__main");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer
   is
      procedure Initialize (Addr : System.Address);
      pragma Import (C, Initialize, "__gnat_initialize");

      procedure Finalize;
      pragma Import (C, Finalize, "__gnat_finalize");
      SEH : aliased array (1 .. 2) of Integer;

      Ensure_Reference : aliased System.Address := Ada_Main_Program_Name'Address;
      pragma Volatile (Ensure_Reference);

   begin
      gnat_argc := argc;
      gnat_argv := argv;
      gnat_envp := envp;

      Initialize (SEH'Address);
      adainit;
      Ada_Main_Program;
      adafinal;
      Finalize;
      return (gnat_exit_status);
   end;

--  BEGIN Object file/option list
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-game_core_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-game_core_event-binary_game_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-game_core_event-match_game_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-game_core_event-unary_game_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-motion_core_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-motion_core_event-catch_motion_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-motion_core_event-move_motion_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-motion_core_event-shot_motion_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-core_event-motion_core_event-tackle_motion_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-field_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-manager_event.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-manager_event-formation.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-manager_event-substitution.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-bridge.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-server.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-utils.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-playerspkg.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-controllerpkg.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-server-callbacks.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-server-websockets.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-server-webserver.o
   --   /home/dextor/scdWorkspace/Soccer-SCD/obj/soccer-main.o
   --   -L/home/dextor/scdWorkspace/Soccer-SCD/obj/
   --   -L/usr/gnat/lib/gnatcoll/static/
   --   -L/usr/gnat/lib/gnat_util/static/
   --   -L/usr/gnat/lib/aws/static/
   --   -L/usr/gnat/lib/xmlada/static/
   --   -L/usr/lib64/
   --   -L/usr/gnat/lib/gcc/x86_64-pc-linux-gnu/4.5.4/adalib/
   --   -static
   --   -lgnarl
   --   -lgnat
   --   -lpthread
--  END Object file/option list   

end ada_main;
