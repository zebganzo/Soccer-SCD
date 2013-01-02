pragma Ada_95;
with System;
package ada_main is
   pragma Warnings (Off);

   gnat_argc : Integer;
   gnat_argv : System.Address;
   gnat_envp : System.Address;

   pragma Import (C, gnat_argc);
   pragma Import (C, gnat_argv);
   pragma Import (C, gnat_envp);

   gnat_exit_status : Integer;
   pragma Import (C, gnat_exit_status);

   GNAT_Version : constant String :=
                    "GNAT Version: GPL 2012 (20120509)" & ASCII.NUL;
   pragma Export (C, GNAT_Version, "__gnat_version");

   Ada_Main_Program_Name : constant String := "_ada_soccer__main" & ASCII.NUL;
   pragma Export (C, Ada_Main_Program_Name, "__gnat_ada_main_program_name");

   procedure adainit;
   pragma Export (C, adainit, "adainit");

   procedure adafinal;
   pragma Export (C, adafinal, "adafinal");

   function main
     (argc : Integer;
      argv : System.Address;
      envp : System.Address)
      return Integer;
   pragma Export (C, main, "main");

   type Version_32 is mod 2 ** 32;
   u00001 : constant Version_32 := 16#a6d7042e#;
   pragma Export (C, u00001, "soccer__mainB");
   u00002 : constant Version_32 := 16#3935bd10#;
   pragma Export (C, u00002, "system__standard_libraryB");
   u00003 : constant Version_32 := 16#e50e0229#;
   pragma Export (C, u00003, "system__standard_libraryS");
   u00004 : constant Version_32 := 16#3ffc8e18#;
   pragma Export (C, u00004, "adaS");
   u00005 : constant Version_32 := 16#5331c1d4#;
   pragma Export (C, u00005, "ada__tagsB");
   u00006 : constant Version_32 := 16#425ab8ea#;
   pragma Export (C, u00006, "ada__tagsS");
   u00007 : constant Version_32 := 16#ebcaf1b3#;
   pragma Export (C, u00007, "ada__exceptionsB");
   u00008 : constant Version_32 := 16#2bc1a577#;
   pragma Export (C, u00008, "ada__exceptionsS");
   u00009 : constant Version_32 := 16#16173147#;
   pragma Export (C, u00009, "ada__exceptions__last_chance_handlerB");
   u00010 : constant Version_32 := 16#e3a511ca#;
   pragma Export (C, u00010, "ada__exceptions__last_chance_handlerS");
   u00011 : constant Version_32 := 16#eb6e42ba#;
   pragma Export (C, u00011, "systemS");
   u00012 : constant Version_32 := 16#0071025c#;
   pragma Export (C, u00012, "system__soft_linksB");
   u00013 : constant Version_32 := 16#7ad2d2f3#;
   pragma Export (C, u00013, "system__soft_linksS");
   u00014 : constant Version_32 := 16#27940d94#;
   pragma Export (C, u00014, "system__parametersB");
   u00015 : constant Version_32 := 16#5d8c4e7a#;
   pragma Export (C, u00015, "system__parametersS");
   u00016 : constant Version_32 := 16#17775d6d#;
   pragma Export (C, u00016, "system__secondary_stackB");
   u00017 : constant Version_32 := 16#ff006514#;
   pragma Export (C, u00017, "system__secondary_stackS");
   u00018 : constant Version_32 := 16#ace32e1e#;
   pragma Export (C, u00018, "system__storage_elementsB");
   u00019 : constant Version_32 := 16#11a33f22#;
   pragma Export (C, u00019, "system__storage_elementsS");
   u00020 : constant Version_32 := 16#4f750b3b#;
   pragma Export (C, u00020, "system__stack_checkingB");
   u00021 : constant Version_32 := 16#48ccfe96#;
   pragma Export (C, u00021, "system__stack_checkingS");
   u00022 : constant Version_32 := 16#7b9f0bae#;
   pragma Export (C, u00022, "system__exception_tableB");
   u00023 : constant Version_32 := 16#7a009e1f#;
   pragma Export (C, u00023, "system__exception_tableS");
   u00024 : constant Version_32 := 16#84debe5c#;
   pragma Export (C, u00024, "system__htableB");
   u00025 : constant Version_32 := 16#68c60cb4#;
   pragma Export (C, u00025, "system__htableS");
   u00026 : constant Version_32 := 16#8b7dad61#;
   pragma Export (C, u00026, "system__string_hashB");
   u00027 : constant Version_32 := 16#cdf29a2e#;
   pragma Export (C, u00027, "system__string_hashS");
   u00028 : constant Version_32 := 16#aad75561#;
   pragma Export (C, u00028, "system__exceptionsB");
   u00029 : constant Version_32 := 16#e7908a0d#;
   pragma Export (C, u00029, "system__exceptionsS");
   u00030 : constant Version_32 := 16#010db1dc#;
   pragma Export (C, u00030, "system__exceptions_debugB");
   u00031 : constant Version_32 := 16#d31e676e#;
   pragma Export (C, u00031, "system__exceptions_debugS");
   u00032 : constant Version_32 := 16#b012ff50#;
   pragma Export (C, u00032, "system__img_intB");
   u00033 : constant Version_32 := 16#e9b5a278#;
   pragma Export (C, u00033, "system__img_intS");
   u00034 : constant Version_32 := 16#dc8e33ed#;
   pragma Export (C, u00034, "system__tracebackB");
   u00035 : constant Version_32 := 16#8ae996cf#;
   pragma Export (C, u00035, "system__tracebackS");
   u00036 : constant Version_32 := 16#907d882f#;
   pragma Export (C, u00036, "system__wch_conB");
   u00037 : constant Version_32 := 16#54856c87#;
   pragma Export (C, u00037, "system__wch_conS");
   u00038 : constant Version_32 := 16#22fed88a#;
   pragma Export (C, u00038, "system__wch_stwB");
   u00039 : constant Version_32 := 16#79944086#;
   pragma Export (C, u00039, "system__wch_stwS");
   u00040 : constant Version_32 := 16#b8a9e30d#;
   pragma Export (C, u00040, "system__wch_cnvB");
   u00041 : constant Version_32 := 16#4a7bea51#;
   pragma Export (C, u00041, "system__wch_cnvS");
   u00042 : constant Version_32 := 16#129923ea#;
   pragma Export (C, u00042, "interfacesS");
   u00043 : constant Version_32 := 16#75729fba#;
   pragma Export (C, u00043, "system__wch_jisB");
   u00044 : constant Version_32 := 16#1e097145#;
   pragma Export (C, u00044, "system__wch_jisS");
   u00045 : constant Version_32 := 16#ada34a87#;
   pragma Export (C, u00045, "system__traceback_entriesB");
   u00046 : constant Version_32 := 16#b94facfb#;
   pragma Export (C, u00046, "system__traceback_entriesS");
   u00047 : constant Version_32 := 16#818f1ecc#;
   pragma Export (C, u00047, "system__unsigned_typesS");
   u00048 : constant Version_32 := 16#68f8d5f8#;
   pragma Export (C, u00048, "system__val_lluB");
   u00049 : constant Version_32 := 16#fb7d49be#;
   pragma Export (C, u00049, "system__val_lluS");
   u00050 : constant Version_32 := 16#46a1f7a9#;
   pragma Export (C, u00050, "system__val_utilB");
   u00051 : constant Version_32 := 16#e0c3d7a5#;
   pragma Export (C, u00051, "system__val_utilS");
   u00052 : constant Version_32 := 16#b7fa72e7#;
   pragma Export (C, u00052, "system__case_utilB");
   u00053 : constant Version_32 := 16#46722232#;
   pragma Export (C, u00053, "system__case_utilS");
   u00054 : constant Version_32 := 16#bc0fac87#;
   pragma Export (C, u00054, "ada__text_ioB");
   u00055 : constant Version_32 := 16#b01682d7#;
   pragma Export (C, u00055, "ada__text_ioS");
   u00056 : constant Version_32 := 16#1358602f#;
   pragma Export (C, u00056, "ada__streamsS");
   u00057 : constant Version_32 := 16#7a48d8b1#;
   pragma Export (C, u00057, "interfaces__c_streamsB");
   u00058 : constant Version_32 := 16#a539be81#;
   pragma Export (C, u00058, "interfaces__c_streamsS");
   u00059 : constant Version_32 := 16#f1fbff23#;
   pragma Export (C, u00059, "system__crtlS");
   u00060 : constant Version_32 := 16#4a803ccf#;
   pragma Export (C, u00060, "system__file_ioB");
   u00061 : constant Version_32 := 16#e6194557#;
   pragma Export (C, u00061, "system__file_ioS");
   u00062 : constant Version_32 := 16#8cbe6205#;
   pragma Export (C, u00062, "ada__finalizationB");
   u00063 : constant Version_32 := 16#22e22193#;
   pragma Export (C, u00063, "ada__finalizationS");
   u00064 : constant Version_32 := 16#95817ed8#;
   pragma Export (C, u00064, "system__finalization_rootB");
   u00065 : constant Version_32 := 16#a49c312a#;
   pragma Export (C, u00065, "system__finalization_rootS");
   u00066 : constant Version_32 := 16#b46168d5#;
   pragma Export (C, u00066, "ada__io_exceptionsS");
   u00067 : constant Version_32 := 16#769e25e6#;
   pragma Export (C, u00067, "interfaces__cB");
   u00068 : constant Version_32 := 16#f05a3eb1#;
   pragma Export (C, u00068, "interfaces__cS");
   u00069 : constant Version_32 := 16#e4d3df20#;
   pragma Export (C, u00069, "interfaces__c__stringsB");
   u00070 : constant Version_32 := 16#603c1c44#;
   pragma Export (C, u00070, "interfaces__c__stringsS");
   u00071 : constant Version_32 := 16#a50435f4#;
   pragma Export (C, u00071, "system__crtl__runtimeS");
   u00072 : constant Version_32 := 16#f4d04ad4#;
   pragma Export (C, u00072, "system__os_libB");
   u00073 : constant Version_32 := 16#a6d80a38#;
   pragma Export (C, u00073, "system__os_libS");
   u00074 : constant Version_32 := 16#4cd8aca0#;
   pragma Export (C, u00074, "system__stringsB");
   u00075 : constant Version_32 := 16#5c84087e#;
   pragma Export (C, u00075, "system__stringsS");
   u00076 : constant Version_32 := 16#3451ac80#;
   pragma Export (C, u00076, "system__file_control_blockS");
   u00077 : constant Version_32 := 16#6d35da9a#;
   pragma Export (C, u00077, "system__finalization_mastersB");
   u00078 : constant Version_32 := 16#819bee96#;
   pragma Export (C, u00078, "system__finalization_mastersS");
   u00079 : constant Version_32 := 16#57a37a42#;
   pragma Export (C, u00079, "system__address_imageB");
   u00080 : constant Version_32 := 16#4a82df80#;
   pragma Export (C, u00080, "system__address_imageS");
   u00081 : constant Version_32 := 16#7268f812#;
   pragma Export (C, u00081, "system__img_boolB");
   u00082 : constant Version_32 := 16#1eb73351#;
   pragma Export (C, u00082, "system__img_boolS");
   u00083 : constant Version_32 := 16#d7aac20c#;
   pragma Export (C, u00083, "system__ioB");
   u00084 : constant Version_32 := 16#752cb5f5#;
   pragma Export (C, u00084, "system__ioS");
   u00085 : constant Version_32 := 16#a7a37cb6#;
   pragma Export (C, u00085, "system__storage_poolsB");
   u00086 : constant Version_32 := 16#38c05dd7#;
   pragma Export (C, u00086, "system__storage_poolsS");
   u00087 : constant Version_32 := 16#ba5d60c7#;
   pragma Export (C, u00087, "system__pool_globalB");
   u00088 : constant Version_32 := 16#d56df0a6#;
   pragma Export (C, u00088, "system__pool_globalS");
   u00089 : constant Version_32 := 16#733fc7cf#;
   pragma Export (C, u00089, "system__memoryB");
   u00090 : constant Version_32 := 16#21e5feaf#;
   pragma Export (C, u00090, "system__memoryS");
   u00091 : constant Version_32 := 16#17551a52#;
   pragma Export (C, u00091, "system__storage_pools__subpoolsB");
   u00092 : constant Version_32 := 16#738e4bc9#;
   pragma Export (C, u00092, "system__storage_pools__subpoolsS");
   u00093 : constant Version_32 := 16#42accdaf#;
   pragma Export (C, u00093, "soccerB");
   u00094 : constant Version_32 := 16#438dabc8#;
   pragma Export (C, u00094, "soccerS");
   u00095 : constant Version_32 := 16#b251ca34#;
   pragma Export (C, u00095, "soccer__bridgeB");
   u00096 : constant Version_32 := 16#7ee42c0a#;
   pragma Export (C, u00096, "soccer__bridgeS");
   u00097 : constant Version_32 := 16#6a5da479#;
   pragma Export (C, u00097, "gnatcollS");
   u00098 : constant Version_32 := 16#ba3c80fb#;
   pragma Export (C, u00098, "gnatcoll__jsonB");
   u00099 : constant Version_32 := 16#90eefe1f#;
   pragma Export (C, u00099, "gnatcoll__jsonS");
   u00100 : constant Version_32 := 16#12c24a43#;
   pragma Export (C, u00100, "ada__charactersS");
   u00101 : constant Version_32 := 16#6239f067#;
   pragma Export (C, u00101, "ada__characters__handlingB");
   u00102 : constant Version_32 := 16#3006d996#;
   pragma Export (C, u00102, "ada__characters__handlingS");
   u00103 : constant Version_32 := 16#051b1b7b#;
   pragma Export (C, u00103, "ada__characters__latin_1S");
   u00104 : constant Version_32 := 16#af50e98f#;
   pragma Export (C, u00104, "ada__stringsS");
   u00105 : constant Version_32 := 16#96e9c1e7#;
   pragma Export (C, u00105, "ada__strings__mapsB");
   u00106 : constant Version_32 := 16#24318e4c#;
   pragma Export (C, u00106, "ada__strings__mapsS");
   u00107 : constant Version_32 := 16#9ffb82dd#;
   pragma Export (C, u00107, "system__bit_opsB");
   u00108 : constant Version_32 := 16#c30e4013#;
   pragma Export (C, u00108, "system__bit_opsS");
   u00109 : constant Version_32 := 16#7a69aa90#;
   pragma Export (C, u00109, "ada__strings__maps__constantsS");
   u00110 : constant Version_32 := 16#261c554b#;
   pragma Export (C, u00110, "ada__strings__unboundedB");
   u00111 : constant Version_32 := 16#2bf53506#;
   pragma Export (C, u00111, "ada__strings__unboundedS");
   u00112 : constant Version_32 := 16#00363e01#;
   pragma Export (C, u00112, "ada__strings__searchB");
   u00113 : constant Version_32 := 16#b5a8c1d6#;
   pragma Export (C, u00113, "ada__strings__searchS");
   u00114 : constant Version_32 := 16#c4857ee1#;
   pragma Export (C, u00114, "system__compare_array_unsigned_8B");
   u00115 : constant Version_32 := 16#3155b477#;
   pragma Export (C, u00115, "system__compare_array_unsigned_8S");
   u00116 : constant Version_32 := 16#9d3d925a#;
   pragma Export (C, u00116, "system__address_operationsB");
   u00117 : constant Version_32 := 16#2b10ab2d#;
   pragma Export (C, u00117, "system__address_operationsS");
   u00118 : constant Version_32 := 16#3b8ad87b#;
   pragma Export (C, u00118, "system__atomic_countersB");
   u00119 : constant Version_32 := 16#a1f22e0e#;
   pragma Export (C, u00119, "system__atomic_countersS");
   u00120 : constant Version_32 := 16#a6e358bc#;
   pragma Export (C, u00120, "system__stream_attributesB");
   u00121 : constant Version_32 := 16#e89b4b3f#;
   pragma Export (C, u00121, "system__stream_attributesS");
   u00122 : constant Version_32 := 16#1991fbe4#;
   pragma Export (C, u00122, "gnatcoll__json__utilityB");
   u00123 : constant Version_32 := 16#e2b00a35#;
   pragma Export (C, u00123, "gnatcoll__json__utilityS");
   u00124 : constant Version_32 := 16#f64b89a4#;
   pragma Export (C, u00124, "ada__integer_text_ioB");
   u00125 : constant Version_32 := 16#f1daf268#;
   pragma Export (C, u00125, "ada__integer_text_ioS");
   u00126 : constant Version_32 := 16#f6fdca1c#;
   pragma Export (C, u00126, "ada__text_io__integer_auxB");
   u00127 : constant Version_32 := 16#b9793d30#;
   pragma Export (C, u00127, "ada__text_io__integer_auxS");
   u00128 : constant Version_32 := 16#515dc0e3#;
   pragma Export (C, u00128, "ada__text_io__generic_auxB");
   u00129 : constant Version_32 := 16#a6c327d3#;
   pragma Export (C, u00129, "ada__text_io__generic_auxS");
   u00130 : constant Version_32 := 16#ef6c8032#;
   pragma Export (C, u00130, "system__img_biuB");
   u00131 : constant Version_32 := 16#47ad9681#;
   pragma Export (C, u00131, "system__img_biuS");
   u00132 : constant Version_32 := 16#10618bf9#;
   pragma Export (C, u00132, "system__img_llbB");
   u00133 : constant Version_32 := 16#066a867f#;
   pragma Export (C, u00133, "system__img_llbS");
   u00134 : constant Version_32 := 16#9777733a#;
   pragma Export (C, u00134, "system__img_lliB");
   u00135 : constant Version_32 := 16#fa21176b#;
   pragma Export (C, u00135, "system__img_lliS");
   u00136 : constant Version_32 := 16#f931f062#;
   pragma Export (C, u00136, "system__img_llwB");
   u00137 : constant Version_32 := 16#af06a5e9#;
   pragma Export (C, u00137, "system__img_llwS");
   u00138 : constant Version_32 := 16#b532ff4e#;
   pragma Export (C, u00138, "system__img_wiuB");
   u00139 : constant Version_32 := 16#29ec1113#;
   pragma Export (C, u00139, "system__img_wiuS");
   u00140 : constant Version_32 := 16#7993dbbd#;
   pragma Export (C, u00140, "system__val_intB");
   u00141 : constant Version_32 := 16#a3cb6885#;
   pragma Export (C, u00141, "system__val_intS");
   u00142 : constant Version_32 := 16#e6965fe6#;
   pragma Export (C, u00142, "system__val_unsB");
   u00143 : constant Version_32 := 16#9127f3f7#;
   pragma Export (C, u00143, "system__val_unsS");
   u00144 : constant Version_32 := 16#936e9286#;
   pragma Export (C, u00144, "system__val_lliB");
   u00145 : constant Version_32 := 16#714aa41a#;
   pragma Export (C, u00145, "system__val_lliS");
   u00146 : constant Version_32 := 16#914b496f#;
   pragma Export (C, u00146, "ada__strings__fixedB");
   u00147 : constant Version_32 := 16#dc686502#;
   pragma Export (C, u00147, "ada__strings__fixedS");
   u00148 : constant Version_32 := 16#fd2ad2f1#;
   pragma Export (C, u00148, "gnatS");
   u00149 : constant Version_32 := 16#509ed097#;
   pragma Export (C, u00149, "gnat__decode_utf8_stringB");
   u00150 : constant Version_32 := 16#868d95c5#;
   pragma Export (C, u00150, "gnat__decode_utf8_stringS");
   u00151 : constant Version_32 := 16#d005f14c#;
   pragma Export (C, u00151, "gnat__encode_utf8_stringB");
   u00152 : constant Version_32 := 16#107345fb#;
   pragma Export (C, u00152, "gnat__encode_utf8_stringS");
   u00153 : constant Version_32 := 16#6d0081c3#;
   pragma Export (C, u00153, "system__img_realB");
   u00154 : constant Version_32 := 16#2cc61358#;
   pragma Export (C, u00154, "system__img_realS");
   u00155 : constant Version_32 := 16#34559c8a#;
   pragma Export (C, u00155, "system__fat_llfS");
   u00156 : constant Version_32 := 16#1b28662b#;
   pragma Export (C, u00156, "system__float_controlB");
   u00157 : constant Version_32 := 16#0b920186#;
   pragma Export (C, u00157, "system__float_controlS");
   u00158 : constant Version_32 := 16#06417083#;
   pragma Export (C, u00158, "system__img_lluB");
   u00159 : constant Version_32 := 16#c8461e0f#;
   pragma Export (C, u00159, "system__img_lluS");
   u00160 : constant Version_32 := 16#194ccd7b#;
   pragma Export (C, u00160, "system__img_unsB");
   u00161 : constant Version_32 := 16#1e7b223b#;
   pragma Export (C, u00161, "system__img_unsS");
   u00162 : constant Version_32 := 16#bb1e24cd#;
   pragma Export (C, u00162, "system__powten_tableS");
   u00163 : constant Version_32 := 16#730c1f82#;
   pragma Export (C, u00163, "system__val_realB");
   u00164 : constant Version_32 := 16#154735ab#;
   pragma Export (C, u00164, "system__val_realS");
   u00165 : constant Version_32 := 16#0be1b996#;
   pragma Export (C, u00165, "system__exn_llfB");
   u00166 : constant Version_32 := 16#6aea5c55#;
   pragma Export (C, u00166, "system__exn_llfS");
   u00167 : constant Version_32 := 16#5e196e91#;
   pragma Export (C, u00167, "ada__containersS");
   u00168 : constant Version_32 := 16#654e2c4c#;
   pragma Export (C, u00168, "ada__containers__hash_tablesS");
   u00169 : constant Version_32 := 16#c24eaf4d#;
   pragma Export (C, u00169, "ada__containers__prime_numbersB");
   u00170 : constant Version_32 := 16#6d3af8ed#;
   pragma Export (C, u00170, "ada__containers__prime_numbersS");
   u00171 : constant Version_32 := 16#bd084245#;
   pragma Export (C, u00171, "ada__strings__hashB");
   u00172 : constant Version_32 := 16#fe83f2e7#;
   pragma Export (C, u00172, "ada__strings__hashS");
   u00173 : constant Version_32 := 16#1eadf3c6#;
   pragma Export (C, u00173, "system__strings__stream_opsB");
   u00174 : constant Version_32 := 16#8453d1c6#;
   pragma Export (C, u00174, "system__strings__stream_opsS");
   u00175 : constant Version_32 := 16#2753da19#;
   pragma Export (C, u00175, "ada__streams__stream_ioB");
   u00176 : constant Version_32 := 16#f0e417a0#;
   pragma Export (C, u00176, "ada__streams__stream_ioS");
   u00177 : constant Version_32 := 16#595ba38f#;
   pragma Export (C, u00177, "system__communicationB");
   u00178 : constant Version_32 := 16#6940ec90#;
   pragma Export (C, u00178, "system__communicationS");
   u00179 : constant Version_32 := 16#04b119fa#;
   pragma Export (C, u00179, "soccer__core_eventS");
   u00180 : constant Version_32 := 16#d7cbcda1#;
   pragma Export (C, u00180, "soccer__core_event__game_core_eventS");
   u00181 : constant Version_32 := 16#28ab1a2a#;
   pragma Export (C, u00181, "soccer__core_event__game_core_event__binary_game_eventB");
   u00182 : constant Version_32 := 16#06cef385#;
   pragma Export (C, u00182, "soccer__core_event__game_core_event__binary_game_eventS");
   u00183 : constant Version_32 := 16#1eab0e09#;
   pragma Export (C, u00183, "system__img_enum_newB");
   u00184 : constant Version_32 := 16#6c69894a#;
   pragma Export (C, u00184, "system__img_enum_newS");
   u00185 : constant Version_32 := 16#0541d2c1#;
   pragma Export (C, u00185, "soccer__core_event__game_core_event__match_game_eventB");
   u00186 : constant Version_32 := 16#bc4b07d1#;
   pragma Export (C, u00186, "soccer__core_event__game_core_event__match_game_eventS");
   u00187 : constant Version_32 := 16#5a50fff8#;
   pragma Export (C, u00187, "soccer__core_event__game_core_event__unary_game_eventB");
   u00188 : constant Version_32 := 16#61db2698#;
   pragma Export (C, u00188, "soccer__core_event__game_core_event__unary_game_eventS");
   u00189 : constant Version_32 := 16#c4d6fa36#;
   pragma Export (C, u00189, "soccer__core_event__motion_core_eventB");
   u00190 : constant Version_32 := 16#09b2b4c5#;
   pragma Export (C, u00190, "soccer__core_event__motion_core_eventS");
   u00191 : constant Version_32 := 16#22237081#;
   pragma Export (C, u00191, "soccer__core_event__motion_core_event__catch_motion_eventS");
   u00192 : constant Version_32 := 16#f54f7d9e#;
   pragma Export (C, u00192, "soccer__core_event__motion_core_event__move_motion_eventS");
   u00193 : constant Version_32 := 16#6229d7cf#;
   pragma Export (C, u00193, "soccer__core_event__motion_core_event__shot_motion_eventB");
   u00194 : constant Version_32 := 16#d1ad7134#;
   pragma Export (C, u00194, "soccer__core_event__motion_core_event__shot_motion_eventS");
   u00195 : constant Version_32 := 16#922ed5f7#;
   pragma Export (C, u00195, "soccer__core_event__motion_core_event__tackle_motion_eventB");
   u00196 : constant Version_32 := 16#2011d0a7#;
   pragma Export (C, u00196, "soccer__core_event__motion_core_event__tackle_motion_eventS");
   u00197 : constant Version_32 := 16#727d6314#;
   pragma Export (C, u00197, "soccer__field_eventB");
   u00198 : constant Version_32 := 16#d9cf9574#;
   pragma Export (C, u00198, "soccer__field_eventS");
   u00199 : constant Version_32 := 16#26e1e5a8#;
   pragma Export (C, u00199, "soccer__manager_eventB");
   u00200 : constant Version_32 := 16#6f362ed1#;
   pragma Export (C, u00200, "soccer__manager_eventS");
   u00201 : constant Version_32 := 16#865fcae6#;
   pragma Export (C, u00201, "soccer__manager_event__formationB");
   u00202 : constant Version_32 := 16#730f64af#;
   pragma Export (C, u00202, "soccer__manager_event__formationS");
   u00203 : constant Version_32 := 16#4457e4fd#;
   pragma Export (C, u00203, "soccer__manager_event__substitutionB");
   u00204 : constant Version_32 := 16#bf48ac01#;
   pragma Export (C, u00204, "soccer__manager_event__substitutionS");
   u00205 : constant Version_32 := 16#bbe5f4c6#;
   pragma Export (C, u00205, "soccer__controllerpkgB");
   u00206 : constant Version_32 := 16#ed67644b#;
   pragma Export (C, u00206, "soccer__controllerpkgS");
   u00207 : constant Version_32 := 16#45724809#;
   pragma Export (C, u00207, "ada__calendar__delaysB");
   u00208 : constant Version_32 := 16#474dd4b1#;
   pragma Export (C, u00208, "ada__calendar__delaysS");
   u00209 : constant Version_32 := 16#8ba0787e#;
   pragma Export (C, u00209, "ada__calendarB");
   u00210 : constant Version_32 := 16#e791e294#;
   pragma Export (C, u00210, "ada__calendarS");
   u00211 : constant Version_32 := 16#22d03640#;
   pragma Export (C, u00211, "system__os_primitivesB");
   u00212 : constant Version_32 := 16#5bbfce93#;
   pragma Export (C, u00212, "system__os_primitivesS");
   u00213 : constant Version_32 := 16#ee80728a#;
   pragma Export (C, u00213, "system__tracesB");
   u00214 : constant Version_32 := 16#19732a10#;
   pragma Export (C, u00214, "system__tracesS");
   u00215 : constant Version_32 := 16#84ad4a42#;
   pragma Export (C, u00215, "ada__numericsS");
   u00216 : constant Version_32 := 16#2d6302ac#;
   pragma Export (C, u00216, "soccer__utilsB");
   u00217 : constant Version_32 := 16#732cd2be#;
   pragma Export (C, u00217, "soccer__utilsS");
   u00218 : constant Version_32 := 16#3e0cf54d#;
   pragma Export (C, u00218, "ada__numerics__auxB");
   u00219 : constant Version_32 := 16#9f6e24ed#;
   pragma Export (C, u00219, "ada__numerics__auxS");
   u00220 : constant Version_32 := 16#e4d53974#;
   pragma Export (C, u00220, "system__machine_codeS");
   u00221 : constant Version_32 := 16#68b73b6d#;
   pragma Export (C, u00221, "system__fat_fltS");
   u00222 : constant Version_32 := 16#39591e91#;
   pragma Export (C, u00222, "system__concat_2B");
   u00223 : constant Version_32 := 16#10beb046#;
   pragma Export (C, u00223, "system__concat_2S");
   u00224 : constant Version_32 := 16#ae97ef6c#;
   pragma Export (C, u00224, "system__concat_3B");
   u00225 : constant Version_32 := 16#9d4440d0#;
   pragma Export (C, u00225, "system__concat_3S");
   u00226 : constant Version_32 := 16#ec38a9a5#;
   pragma Export (C, u00226, "system__concat_7B");
   u00227 : constant Version_32 := 16#f739b1a0#;
   pragma Export (C, u00227, "system__concat_7S");
   u00228 : constant Version_32 := 16#c9fdc962#;
   pragma Export (C, u00228, "system__concat_6B");
   u00229 : constant Version_32 := 16#2ca4b7ae#;
   pragma Export (C, u00229, "system__concat_6S");
   u00230 : constant Version_32 := 16#def1dd00#;
   pragma Export (C, u00230, "system__concat_5B");
   u00231 : constant Version_32 := 16#fb578c1b#;
   pragma Export (C, u00231, "system__concat_5S");
   u00232 : constant Version_32 := 16#3493e6c0#;
   pragma Export (C, u00232, "system__concat_4B");
   u00233 : constant Version_32 := 16#e931a104#;
   pragma Export (C, u00233, "system__concat_4S");
   u00234 : constant Version_32 := 16#ccec2ba2#;
   pragma Export (C, u00234, "system__taskingB");
   u00235 : constant Version_32 := 16#3f81803c#;
   pragma Export (C, u00235, "system__taskingS");
   u00236 : constant Version_32 := 16#6d133e11#;
   pragma Export (C, u00236, "system__task_primitivesS");
   u00237 : constant Version_32 := 16#e0522444#;
   pragma Export (C, u00237, "system__os_interfaceB");
   u00238 : constant Version_32 := 16#35faef2d#;
   pragma Export (C, u00238, "system__os_interfaceS");
   u00239 : constant Version_32 := 16#9ba989ff#;
   pragma Export (C, u00239, "system__linuxS");
   u00240 : constant Version_32 := 16#2f5dc06d#;
   pragma Export (C, u00240, "system__os_constantsS");
   u00241 : constant Version_32 := 16#b4921ea2#;
   pragma Export (C, u00241, "system__task_primitives__operationsB");
   u00242 : constant Version_32 := 16#73696aed#;
   pragma Export (C, u00242, "system__task_primitives__operationsS");
   u00243 : constant Version_32 := 16#903909a4#;
   pragma Export (C, u00243, "system__interrupt_managementB");
   u00244 : constant Version_32 := 16#6b7e2624#;
   pragma Export (C, u00244, "system__interrupt_managementS");
   u00245 : constant Version_32 := 16#c313b593#;
   pragma Export (C, u00245, "system__multiprocessorsB");
   u00246 : constant Version_32 := 16#d3c2ddc9#;
   pragma Export (C, u00246, "system__multiprocessorsS");
   u00247 : constant Version_32 := 16#55faabf1#;
   pragma Export (C, u00247, "system__stack_checking__operationsB");
   u00248 : constant Version_32 := 16#49df1cef#;
   pragma Export (C, u00248, "system__stack_checking__operationsS");
   u00249 : constant Version_32 := 16#3d54d5f6#;
   pragma Export (C, u00249, "system__task_infoB");
   u00250 : constant Version_32 := 16#59d440ea#;
   pragma Export (C, u00250, "system__task_infoS");
   u00251 : constant Version_32 := 16#2a6dd755#;
   pragma Export (C, u00251, "system__tasking__debugB");
   u00252 : constant Version_32 := 16#8c562538#;
   pragma Export (C, u00252, "system__tasking__debugS");
   u00253 : constant Version_32 := 16#7b8aedca#;
   pragma Export (C, u00253, "system__stack_usageB");
   u00254 : constant Version_32 := 16#a5188558#;
   pragma Export (C, u00254, "system__stack_usageS");
   u00255 : constant Version_32 := 16#5a8b2f09#;
   pragma Export (C, u00255, "system__tasking__rendezvousB");
   u00256 : constant Version_32 := 16#34f28e26#;
   pragma Export (C, u00256, "system__tasking__rendezvousS");
   u00257 : constant Version_32 := 16#386436bc#;
   pragma Export (C, u00257, "system__restrictionsB");
   u00258 : constant Version_32 := 16#a7a3f233#;
   pragma Export (C, u00258, "system__restrictionsS");
   u00259 : constant Version_32 := 16#ee28ed55#;
   pragma Export (C, u00259, "system__tasking__entry_callsB");
   u00260 : constant Version_32 := 16#84b0eb9c#;
   pragma Export (C, u00260, "system__tasking__entry_callsS");
   u00261 : constant Version_32 := 16#176ce286#;
   pragma Export (C, u00261, "system__tasking__initializationB");
   u00262 : constant Version_32 := 16#93a57cc9#;
   pragma Export (C, u00262, "system__tasking__initializationS");
   u00263 : constant Version_32 := 16#695e2a32#;
   pragma Export (C, u00263, "system__soft_links__taskingB");
   u00264 : constant Version_32 := 16#6ac0d6d0#;
   pragma Export (C, u00264, "system__soft_links__taskingS");
   u00265 : constant Version_32 := 16#17d21067#;
   pragma Export (C, u00265, "ada__exceptions__is_null_occurrenceB");
   u00266 : constant Version_32 := 16#24d5007b#;
   pragma Export (C, u00266, "ada__exceptions__is_null_occurrenceS");
   u00267 : constant Version_32 := 16#f85ea1d6#;
   pragma Export (C, u00267, "system__tasking__protected_objectsB");
   u00268 : constant Version_32 := 16#0e06b2d3#;
   pragma Export (C, u00268, "system__tasking__protected_objectsS");
   u00269 : constant Version_32 := 16#e844a3d9#;
   pragma Export (C, u00269, "system__tasking__protected_objects__entriesB");
   u00270 : constant Version_32 := 16#db92b260#;
   pragma Export (C, u00270, "system__tasking__protected_objects__entriesS");
   u00271 : constant Version_32 := 16#c468a124#;
   pragma Export (C, u00271, "system__tasking__protected_objects__operationsB");
   u00272 : constant Version_32 := 16#c3da2e0f#;
   pragma Export (C, u00272, "system__tasking__protected_objects__operationsS");
   u00273 : constant Version_32 := 16#385ecace#;
   pragma Export (C, u00273, "system__tasking__queuingB");
   u00274 : constant Version_32 := 16#ca5254e7#;
   pragma Export (C, u00274, "system__tasking__queuingS");
   u00275 : constant Version_32 := 16#5270cf31#;
   pragma Export (C, u00275, "system__tasking__utilitiesB");
   u00276 : constant Version_32 := 16#588eda2e#;
   pragma Export (C, u00276, "system__tasking__utilitiesS");
   u00277 : constant Version_32 := 16#bd6fc52e#;
   pragma Export (C, u00277, "system__traces__taskingB");
   u00278 : constant Version_32 := 16#52029525#;
   pragma Export (C, u00278, "system__traces__taskingS");
   u00279 : constant Version_32 := 16#1d50dbf5#;
   pragma Export (C, u00279, "system__tasking__stagesB");
   u00280 : constant Version_32 := 16#9022d0bb#;
   pragma Export (C, u00280, "system__tasking__stagesS");
   u00281 : constant Version_32 := 16#6cdeae02#;
   pragma Export (C, u00281, "ada__real_timeB");
   u00282 : constant Version_32 := 16#41de19c7#;
   pragma Export (C, u00282, "ada__real_timeS");
   u00283 : constant Version_32 := 16#93d8ec4d#;
   pragma Export (C, u00283, "system__arith_64B");
   u00284 : constant Version_32 := 16#59e6c039#;
   pragma Export (C, u00284, "system__arith_64S");
   u00285 : constant Version_32 := 16#34388218#;
   pragma Export (C, u00285, "soccer__playerspkgB");
   u00286 : constant Version_32 := 16#fe002251#;
   pragma Export (C, u00286, "soccer__playerspkgS");
   u00287 : constant Version_32 := 16#4be972ea#;
   pragma Export (C, u00287, "soccer__serverS");
   u00288 : constant Version_32 := 16#91c0a5ae#;
   pragma Export (C, u00288, "soccer__server__webserverB");
   u00289 : constant Version_32 := 16#751ce286#;
   pragma Export (C, u00289, "soccer__server__webserverS");
   u00290 : constant Version_32 := 16#7408e15f#;
   pragma Export (C, u00290, "awsS");
   u00291 : constant Version_32 := 16#be63b727#;
   pragma Export (C, u00291, "aws__configB");
   u00292 : constant Version_32 := 16#bddcef89#;
   pragma Export (C, u00292, "aws__configS");
   u00293 : constant Version_32 := 16#3e4e6762#;
   pragma Export (C, u00293, "ada__directoriesB");
   u00294 : constant Version_32 := 16#9c33e8ea#;
   pragma Export (C, u00294, "ada__directoriesS");
   u00295 : constant Version_32 := 16#7a13e6d7#;
   pragma Export (C, u00295, "ada__calendar__formattingB");
   u00296 : constant Version_32 := 16#929f882b#;
   pragma Export (C, u00296, "ada__calendar__formattingS");
   u00297 : constant Version_32 := 16#e3cca715#;
   pragma Export (C, u00297, "ada__calendar__time_zonesB");
   u00298 : constant Version_32 := 16#98f012d7#;
   pragma Export (C, u00298, "ada__calendar__time_zonesS");
   u00299 : constant Version_32 := 16#e559f18d#;
   pragma Export (C, u00299, "ada__directories__validityB");
   u00300 : constant Version_32 := 16#a2334639#;
   pragma Export (C, u00300, "ada__directories__validityS");
   u00301 : constant Version_32 := 16#e7698cad#;
   pragma Export (C, u00301, "system__regexpB");
   u00302 : constant Version_32 := 16#25ffb906#;
   pragma Export (C, u00302, "system__regexpS");
   u00303 : constant Version_32 := 16#9c9c5e59#;
   pragma Export (C, u00303, "aws__config__iniB");
   u00304 : constant Version_32 := 16#f6af931c#;
   pragma Export (C, u00304, "aws__config__iniS");
   u00305 : constant Version_32 := 16#2c2cb25a#;
   pragma Export (C, u00305, "ada__command_lineB");
   u00306 : constant Version_32 := 16#df5044bd#;
   pragma Export (C, u00306, "ada__command_lineS");
   u00307 : constant Version_32 := 16#8c2ac8f2#;
   pragma Export (C, u00307, "aws__config__utilsB");
   u00308 : constant Version_32 := 16#17897cd2#;
   pragma Export (C, u00308, "aws__config__utilsS");
   u00309 : constant Version_32 := 16#21b971f7#;
   pragma Export (C, u00309, "aws__netB");
   u00310 : constant Version_32 := 16#96db4796#;
   pragma Export (C, u00310, "aws__netS");
   u00311 : constant Version_32 := 16#dd70d2a7#;
   pragma Export (C, u00311, "aws__net__logB");
   u00312 : constant Version_32 := 16#176fa800#;
   pragma Export (C, u00312, "aws__net__logS");
   u00313 : constant Version_32 := 16#73c015e2#;
   pragma Export (C, u00313, "aws__utilsB");
   u00314 : constant Version_32 := 16#20fe9701#;
   pragma Export (C, u00314, "aws__utilsS");
   u00315 : constant Version_32 := 16#7620113d#;
   pragma Export (C, u00315, "ada__numerics__long_elementary_functionsB");
   u00316 : constant Version_32 := 16#e948d6ae#;
   pragma Export (C, u00316, "ada__numerics__long_elementary_functionsS");
   u00317 : constant Version_32 := 16#4e853260#;
   pragma Export (C, u00317, "system__fat_lfltS");
   u00318 : constant Version_32 := 16#96529d59#;
   pragma Export (C, u00318, "ada__task_identificationB");
   u00319 : constant Version_32 := 16#2e3eb6a6#;
   pragma Export (C, u00319, "ada__task_identificationS");
   u00320 : constant Version_32 := 16#d5f9759f#;
   pragma Export (C, u00320, "ada__text_io__float_auxB");
   u00321 : constant Version_32 := 16#f854caf5#;
   pragma Export (C, u00321, "ada__text_io__float_auxS");
   u00322 : constant Version_32 := 16#94cd4116#;
   pragma Export (C, u00322, "aws__os_libS");
   u00323 : constant Version_32 := 16#10f589ff#;
   pragma Export (C, u00323, "gnat__os_libS");
   u00324 : constant Version_32 := 16#dd13bf65#;
   pragma Export (C, u00324, "system__exn_lliB");
   u00325 : constant Version_32 := 16#6af93915#;
   pragma Export (C, u00325, "system__exn_lliS");
   u00326 : constant Version_32 := 16#276453b7#;
   pragma Export (C, u00326, "system__img_lldB");
   u00327 : constant Version_32 := 16#184c4bd3#;
   pragma Export (C, u00327, "system__img_lldS");
   u00328 : constant Version_32 := 16#8da1623b#;
   pragma Export (C, u00328, "system__img_decB");
   u00329 : constant Version_32 := 16#45434b61#;
   pragma Export (C, u00329, "system__img_decS");
   u00330 : constant Version_32 := 16#5ffcea55#;
   pragma Export (C, u00330, "system__random_numbersB");
   u00331 : constant Version_32 := 16#a7445e5a#;
   pragma Export (C, u00331, "system__random_numbersS");
   u00332 : constant Version_32 := 16#7d397bc7#;
   pragma Export (C, u00332, "system__random_seedB");
   u00333 : constant Version_32 := 16#f8521a63#;
   pragma Export (C, u00333, "system__random_seedS");
   u00334 : constant Version_32 := 16#5c7df71d#;
   pragma Export (C, u00334, "templates_parserB");
   u00335 : constant Version_32 := 16#90cfa7dd#;
   pragma Export (C, u00335, "templates_parserS");
   u00336 : constant Version_32 := 16#e5d07804#;
   pragma Export (C, u00336, "ada__strings__hash_case_insensitiveB");
   u00337 : constant Version_32 := 16#f9e6d5c1#;
   pragma Export (C, u00337, "ada__strings__hash_case_insensitiveS");
   u00338 : constant Version_32 := 16#e1f42065#;
   pragma Export (C, u00338, "gnat__calendarB");
   u00339 : constant Version_32 := 16#d73dae4e#;
   pragma Export (C, u00339, "gnat__calendarS");
   u00340 : constant Version_32 := 16#8bfb0aae#;
   pragma Export (C, u00340, "gnat__calendar__time_ioB");
   u00341 : constant Version_32 := 16#1efff27c#;
   pragma Export (C, u00341, "gnat__calendar__time_ioS");
   u00342 : constant Version_32 := 16#d37ed4a2#;
   pragma Export (C, u00342, "gnat__case_utilB");
   u00343 : constant Version_32 := 16#5f04590f#;
   pragma Export (C, u00343, "gnat__case_utilS");
   u00344 : constant Version_32 := 16#c72dc161#;
   pragma Export (C, u00344, "gnat__regpatS");
   u00345 : constant Version_32 := 16#b97b88d3#;
   pragma Export (C, u00345, "system__regpatB");
   u00346 : constant Version_32 := 16#6934d9c5#;
   pragma Export (C, u00346, "system__regpatS");
   u00347 : constant Version_32 := 16#2b93a046#;
   pragma Export (C, u00347, "system__img_charB");
   u00348 : constant Version_32 := 16#775a1a5d#;
   pragma Export (C, u00348, "system__img_charS");
   u00349 : constant Version_32 := 16#be2e439b#;
   pragma Export (C, u00349, "templates_parser__configurationS");
   u00350 : constant Version_32 := 16#d33964a0#;
   pragma Export (C, u00350, "aws__resourcesB");
   u00351 : constant Version_32 := 16#d28cfca0#;
   pragma Export (C, u00351, "aws__resourcesS");
   u00352 : constant Version_32 := 16#ad37b682#;
   pragma Export (C, u00352, "aws__resources__embeddedB");
   u00353 : constant Version_32 := 16#f849ea1b#;
   pragma Export (C, u00353, "aws__resources__embeddedS");
   u00354 : constant Version_32 := 16#f77d616a#;
   pragma Export (C, u00354, "aws__resources__streamsB");
   u00355 : constant Version_32 := 16#e977adac#;
   pragma Export (C, u00355, "aws__resources__streamsS");
   u00356 : constant Version_32 := 16#9c79590e#;
   pragma Export (C, u00356, "aws__resources__streams__zlibB");
   u00357 : constant Version_32 := 16#a6153e9d#;
   pragma Export (C, u00357, "aws__resources__streams__zlibS");
   u00358 : constant Version_32 := 16#97516069#;
   pragma Export (C, u00358, "zlibB");
   u00359 : constant Version_32 := 16#ef568679#;
   pragma Export (C, u00359, "zlibS");
   u00360 : constant Version_32 := 16#6da86201#;
   pragma Export (C, u00360, "zlib__thinB");
   u00361 : constant Version_32 := 16#1b9cd18a#;
   pragma Export (C, u00361, "zlib__thinS");
   u00362 : constant Version_32 := 16#2086cae7#;
   pragma Export (C, u00362, "aws__resources__streams__memoryB");
   u00363 : constant Version_32 := 16#ecd5a206#;
   pragma Export (C, u00363, "aws__resources__streams__memoryS");
   u00364 : constant Version_32 := 16#13522ec4#;
   pragma Export (C, u00364, "aws__containersS");
   u00365 : constant Version_32 := 16#3ed79265#;
   pragma Export (C, u00365, "aws__containers__memory_streamsB");
   u00366 : constant Version_32 := 16#a7580186#;
   pragma Export (C, u00366, "aws__containers__memory_streamsS");
   u00367 : constant Version_32 := 16#067abc3d#;
   pragma Export (C, u00367, "memory_streamsB");
   u00368 : constant Version_32 := 16#e7c465d7#;
   pragma Export (C, u00368, "memory_streamsS");
   u00369 : constant Version_32 := 16#2fc49771#;
   pragma Export (C, u00369, "aws__resources__filesB");
   u00370 : constant Version_32 := 16#3de30e34#;
   pragma Export (C, u00370, "aws__resources__filesS");
   u00371 : constant Version_32 := 16#296a0858#;
   pragma Export (C, u00371, "aws__resources__streams__diskB");
   u00372 : constant Version_32 := 16#3a561ded#;
   pragma Export (C, u00372, "aws__resources__streams__diskS");
   u00373 : constant Version_32 := 16#ad82726d#;
   pragma Export (C, u00373, "templates_parser__inputB");
   u00374 : constant Version_32 := 16#3005180c#;
   pragma Export (C, u00374, "templates_parser__inputS");
   u00375 : constant Version_32 := 16#0a711e7b#;
   pragma Export (C, u00375, "templates_parser__utilsB");
   u00376 : constant Version_32 := 16#506bbeec#;
   pragma Export (C, u00376, "templates_parser__utilsS");
   u00377 : constant Version_32 := 16#3be31a7b#;
   pragma Export (C, u00377, "ada__environment_variablesB");
   u00378 : constant Version_32 := 16#35b9fcf5#;
   pragma Export (C, u00378, "ada__environment_variablesS");
   u00379 : constant Version_32 := 16#0a12f45b#;
   pragma Export (C, u00379, "templates_parser_taskingB");
   u00380 : constant Version_32 := 16#4c0209f0#;
   pragma Export (C, u00380, "templates_parser_taskingS");
   u00381 : constant Version_32 := 16#ebcf91d1#;
   pragma Export (C, u00381, "aws__net__poll_eventsB");
   u00382 : constant Version_32 := 16#9bcb44f6#;
   pragma Export (C, u00382, "aws__net__poll_eventsS");
   u00383 : constant Version_32 := 16#1247cafb#;
   pragma Export (C, u00383, "aws__net__sslB");
   u00384 : constant Version_32 := 16#db9625eb#;
   pragma Export (C, u00384, "aws__net__sslS");
   u00385 : constant Version_32 := 16#b158d5c2#;
   pragma Export (C, u00385, "aws__net__stdB");
   u00386 : constant Version_32 := 16#5d1c3a62#;
   pragma Export (C, u00386, "aws__net__stdS");
   u00387 : constant Version_32 := 16#40026144#;
   pragma Export (C, u00387, "gnat__socketsB");
   u00388 : constant Version_32 := 16#fe67e047#;
   pragma Export (C, u00388, "gnat__socketsS");
   u00389 : constant Version_32 := 16#71ef3485#;
   pragma Export (C, u00389, "gnat__sockets__linker_optionsS");
   u00390 : constant Version_32 := 16#fe13f6dc#;
   pragma Export (C, u00390, "gnat__sockets__thinB");
   u00391 : constant Version_32 := 16#d49b4bc0#;
   pragma Export (C, u00391, "gnat__sockets__thinS");
   u00392 : constant Version_32 := 16#43a82adc#;
   pragma Export (C, u00392, "gnat__task_lockS");
   u00393 : constant Version_32 := 16#c57e63fb#;
   pragma Export (C, u00393, "system__task_lockB");
   u00394 : constant Version_32 := 16#c9a583b9#;
   pragma Export (C, u00394, "system__task_lockS");
   u00395 : constant Version_32 := 16#28ed06f8#;
   pragma Export (C, u00395, "gnat__sockets__thin_commonB");
   u00396 : constant Version_32 := 16#18f9d05e#;
   pragma Export (C, u00396, "gnat__sockets__thin_commonS");
   u00397 : constant Version_32 := 16#17f3840e#;
   pragma Export (C, u00397, "system__pool_sizeB");
   u00398 : constant Version_32 := 16#f7a0d753#;
   pragma Export (C, u00398, "system__pool_sizeS");
   u00399 : constant Version_32 := 16#95b3c232#;
   pragma Export (C, u00399, "gnat__sockets__constantsS");
   u00400 : constant Version_32 := 16#72140dcf#;
   pragma Export (C, u00400, "sslS");
   u00401 : constant Version_32 := 16#82273f9a#;
   pragma Export (C, u00401, "ssl__thinS");
   u00402 : constant Version_32 := 16#1915d429#;
   pragma Export (C, u00402, "aws__net__bufferedB");
   u00403 : constant Version_32 := 16#23484d11#;
   pragma Export (C, u00403, "aws__net__bufferedS");
   u00404 : constant Version_32 := 16#93ca5154#;
   pragma Export (C, u00404, "aws__defaultS");
   u00405 : constant Version_32 := 16#47a671f6#;
   pragma Export (C, u00405, "aws__translatorB");
   u00406 : constant Version_32 := 16#2e55d20e#;
   pragma Export (C, u00406, "aws__translatorS");
   u00407 : constant Version_32 := 16#cde45eef#;
   pragma Export (C, u00407, "aws__resources__streams__memory__zlibB");
   u00408 : constant Version_32 := 16#18a1c553#;
   pragma Export (C, u00408, "aws__resources__streams__memory__zlibS");
   u00409 : constant Version_32 := 16#5c0e4566#;
   pragma Export (C, u00409, "system__val_boolB");
   u00410 : constant Version_32 := 16#11fc2ea4#;
   pragma Export (C, u00410, "system__val_boolS");
   u00411 : constant Version_32 := 16#96c125d4#;
   pragma Export (C, u00411, "system__val_enumB");
   u00412 : constant Version_32 := 16#5074002f#;
   pragma Export (C, u00412, "system__val_enumS");
   u00413 : constant Version_32 := 16#b5692847#;
   pragma Export (C, u00413, "aws__containers__string_vectorsB");
   u00414 : constant Version_32 := 16#745811be#;
   pragma Export (C, u00414, "aws__containers__string_vectorsS");
   u00415 : constant Version_32 := 16#084c16d0#;
   pragma Export (C, u00415, "gnat__regexpS");
   u00416 : constant Version_32 := 16#5fa42d7b#;
   pragma Export (C, u00416, "aws__config__setB");
   u00417 : constant Version_32 := 16#2fabcad8#;
   pragma Export (C, u00417, "aws__config__setS");
   u00418 : constant Version_32 := 16#4514ace0#;
   pragma Export (C, u00418, "aws__net__websocketB");
   u00419 : constant Version_32 := 16#f1c70145#;
   pragma Export (C, u00419, "aws__net__websocketS");
   u00420 : constant Version_32 := 16#2b46fa21#;
   pragma Export (C, u00420, "aws__headersB");
   u00421 : constant Version_32 := 16#6281c1d4#;
   pragma Export (C, u00421, "aws__headersS");
   u00422 : constant Version_32 := 16#bdaf6514#;
   pragma Export (C, u00422, "aws__containers__tablesB");
   u00423 : constant Version_32 := 16#9d262e7d#;
   pragma Export (C, u00423, "aws__containers__tablesS");
   u00424 : constant Version_32 := 16#d9473c8c#;
   pragma Export (C, u00424, "ada__containers__red_black_treesS");
   u00425 : constant Version_32 := 16#c62a4e6b#;
   pragma Export (C, u00425, "aws__messagesB");
   u00426 : constant Version_32 := 16#26a46bd6#;
   pragma Export (C, u00426, "aws__messagesS");
   u00427 : constant Version_32 := 16#4e5bc6ea#;
   pragma Export (C, u00427, "aws__headers__valuesB");
   u00428 : constant Version_32 := 16#324be5d4#;
   pragma Export (C, u00428, "aws__headers__valuesS");
   u00429 : constant Version_32 := 16#ef030c2a#;
   pragma Export (C, u00429, "aws__net__websocket__protocolS");
   u00430 : constant Version_32 := 16#9b3370e3#;
   pragma Export (C, u00430, "aws__net__websocket__protocol__draft76B");
   u00431 : constant Version_32 := 16#b2357620#;
   pragma Export (C, u00431, "aws__net__websocket__protocol__draft76S");
   u00432 : constant Version_32 := 16#18a01aec#;
   pragma Export (C, u00432, "gnat__byte_swappingB");
   u00433 : constant Version_32 := 16#b2968672#;
   pragma Export (C, u00433, "gnat__byte_swappingS");
   u00434 : constant Version_32 := 16#bb55398e#;
   pragma Export (C, u00434, "gnat__md5B");
   u00435 : constant Version_32 := 16#d831bc41#;
   pragma Export (C, u00435, "gnat__md5S");
   u00436 : constant Version_32 := 16#4ce84ced#;
   pragma Export (C, u00436, "gnat__secure_hashesB");
   u00437 : constant Version_32 := 16#ad29e124#;
   pragma Export (C, u00437, "gnat__secure_hashesS");
   u00438 : constant Version_32 := 16#462993a2#;
   pragma Export (C, u00438, "gnat__secure_hashes__md5B");
   u00439 : constant Version_32 := 16#463b9ce5#;
   pragma Export (C, u00439, "gnat__secure_hashes__md5S");
   u00440 : constant Version_32 := 16#f1b33474#;
   pragma Export (C, u00440, "aws__net__websocket__protocol__rfc6455B");
   u00441 : constant Version_32 := 16#04787004#;
   pragma Export (C, u00441, "aws__net__websocket__protocol__rfc6455S");
   u00442 : constant Version_32 := 16#077f0b47#;
   pragma Export (C, u00442, "gnat__sha1B");
   u00443 : constant Version_32 := 16#77882a94#;
   pragma Export (C, u00443, "gnat__sha1S");
   u00444 : constant Version_32 := 16#cadfacae#;
   pragma Export (C, u00444, "gnat__secure_hashes__sha1B");
   u00445 : constant Version_32 := 16#55a838f9#;
   pragma Export (C, u00445, "gnat__secure_hashes__sha1S");
   u00446 : constant Version_32 := 16#b897f480#;
   pragma Export (C, u00446, "aws__statusB");
   u00447 : constant Version_32 := 16#3b1aabd0#;
   pragma Export (C, u00447, "aws__statusS");
   u00448 : constant Version_32 := 16#3c979f74#;
   pragma Export (C, u00448, "aws__digestB");
   u00449 : constant Version_32 := 16#dda59b50#;
   pragma Export (C, u00449, "aws__digestS");
   u00450 : constant Version_32 := 16#f132764c#;
   pragma Export (C, u00450, "aws__attachmentsB");
   u00451 : constant Version_32 := 16#31cb3c60#;
   pragma Export (C, u00451, "aws__attachmentsS");
   u00452 : constant Version_32 := 16#79293567#;
   pragma Export (C, u00452, "aws__headers__setB");
   u00453 : constant Version_32 := 16#ea43438c#;
   pragma Export (C, u00453, "aws__headers__setS");
   u00454 : constant Version_32 := 16#99ca9f94#;
   pragma Export (C, u00454, "aws__containers__tables__setB");
   u00455 : constant Version_32 := 16#9a446e2e#;
   pragma Export (C, u00455, "aws__containers__tables__setS");
   u00456 : constant Version_32 := 16#cd2caee2#;
   pragma Export (C, u00456, "aws__mimeB");
   u00457 : constant Version_32 := 16#c580e2c1#;
   pragma Export (C, u00457, "aws__mimeS");
   u00458 : constant Version_32 := 16#677c101f#;
   pragma Export (C, u00458, "aws__parametersB");
   u00459 : constant Version_32 := 16#29b9dd13#;
   pragma Export (C, u00459, "aws__parametersS");
   u00460 : constant Version_32 := 16#804d3ef9#;
   pragma Export (C, u00460, "aws__sessionB");
   u00461 : constant Version_32 := 16#e5b4a266#;
   pragma Export (C, u00461, "aws__sessionS");
   u00462 : constant Version_32 := 16#f3f917f0#;
   pragma Export (C, u00462, "aws__containers__key_valueB");
   u00463 : constant Version_32 := 16#9029d814#;
   pragma Export (C, u00463, "aws__containers__key_valueS");
   u00464 : constant Version_32 := 16#a1212469#;
   pragma Export (C, u00464, "aws__utils__streamsB");
   u00465 : constant Version_32 := 16#e3a06472#;
   pragma Export (C, u00465, "aws__utils__streamsS");
   u00466 : constant Version_32 := 16#c36fa9c0#;
   pragma Export (C, u00466, "aws__urlB");
   u00467 : constant Version_32 := 16#be815658#;
   pragma Export (C, u00467, "aws__urlS");
   u00468 : constant Version_32 := 16#daf4210b#;
   pragma Export (C, u00468, "aws__url__raise_url_errorB");
   u00469 : constant Version_32 := 16#f16a29a7#;
   pragma Export (C, u00469, "aws__url__raise_url_errorS");
   u00470 : constant Version_32 := 16#06b85c36#;
   pragma Export (C, u00470, "aws__url__setB");
   u00471 : constant Version_32 := 16#9e90154b#;
   pragma Export (C, u00471, "aws__url__setS");
   u00472 : constant Version_32 := 16#c78b4aa4#;
   pragma Export (C, u00472, "aws__parameters__setB");
   u00473 : constant Version_32 := 16#cd0a685a#;
   pragma Export (C, u00473, "aws__parameters__setS");
   u00474 : constant Version_32 := 16#1b8e29e2#;
   pragma Export (C, u00474, "aws__serverB");
   u00475 : constant Version_32 := 16#90dbb97c#;
   pragma Export (C, u00475, "aws__serverS");
   u00476 : constant Version_32 := 16#47d9fc73#;
   pragma Export (C, u00476, "aws__dispatchersB");
   u00477 : constant Version_32 := 16#ad059557#;
   pragma Export (C, u00477, "aws__dispatchersS");
   u00478 : constant Version_32 := 16#e3b90299#;
   pragma Export (C, u00478, "aws__responseB");
   u00479 : constant Version_32 := 16#00a17556#;
   pragma Export (C, u00479, "aws__responseS");
   u00480 : constant Version_32 := 16#a97610f3#;
   pragma Export (C, u00480, "aws__resources__streams__disk__onceB");
   u00481 : constant Version_32 := 16#d13e0a43#;
   pragma Export (C, u00481, "aws__resources__streams__disk__onceS");
   u00482 : constant Version_32 := 16#325fa292#;
   pragma Export (C, u00482, "aws__response__setB");
   u00483 : constant Version_32 := 16#6289a834#;
   pragma Export (C, u00483, "aws__response__setS");
   u00484 : constant Version_32 := 16#5519b6d1#;
   pragma Export (C, u00484, "aws__dispatchers__callbackB");
   u00485 : constant Version_32 := 16#f1d0ce2a#;
   pragma Export (C, u00485, "aws__dispatchers__callbackS");
   u00486 : constant Version_32 := 16#49c52c77#;
   pragma Export (C, u00486, "aws__logB");
   u00487 : constant Version_32 := 16#f3f4d519#;
   pragma Export (C, u00487, "aws__logS");
   u00488 : constant Version_32 := 16#f22bbd5c#;
   pragma Export (C, u00488, "ada__text_io__c_streamsB");
   u00489 : constant Version_32 := 16#e3554943#;
   pragma Export (C, u00489, "ada__text_io__c_streamsS");
   u00490 : constant Version_32 := 16#e1e7a18e#;
   pragma Export (C, u00490, "aws__net__websocket__registryB");
   u00491 : constant Version_32 := 16#2b4333b0#;
   pragma Export (C, u00491, "aws__net__websocket__registryS");
   u00492 : constant Version_32 := 16#661228ef#;
   pragma Export (C, u00492, "aws__net__generic_setsB");
   u00493 : constant Version_32 := 16#1fa1cb67#;
   pragma Export (C, u00493, "aws__net__generic_setsS");
   u00494 : constant Version_32 := 16#1da432b2#;
   pragma Export (C, u00494, "aws__net__websocket__registry__controlB");
   u00495 : constant Version_32 := 16#3605382d#;
   pragma Export (C, u00495, "aws__net__websocket__registry__controlS");
   u00496 : constant Version_32 := 16#81e4c393#;
   pragma Export (C, u00496, "aws__server__http_utilsB");
   u00497 : constant Version_32 := 16#7c6b9671#;
   pragma Export (C, u00497, "aws__server__http_utilsS");
   u00498 : constant Version_32 := 16#74bccff5#;
   pragma Export (C, u00498, "aws__hotplugB");
   u00499 : constant Version_32 := 16#8f209e19#;
   pragma Export (C, u00499, "aws__hotplugS");
   u00500 : constant Version_32 := 16#1f6ab9be#;
   pragma Export (C, u00500, "aws__clientB");
   u00501 : constant Version_32 := 16#108e29c1#;
   pragma Export (C, u00501, "aws__clientS");
   u00502 : constant Version_32 := 16#309ffe0e#;
   pragma Export (C, u00502, "aws__client__http_utilsB");
   u00503 : constant Version_32 := 16#3d43e040#;
   pragma Export (C, u00503, "aws__client__http_utilsS");
   u00504 : constant Version_32 := 16#979811c1#;
   pragma Export (C, u00504, "aws__net__ssl__certificateB");
   u00505 : constant Version_32 := 16#126c8670#;
   pragma Export (C, u00505, "aws__net__ssl__certificateS");
   u00506 : constant Version_32 := 16#8fd3e631#;
   pragma Export (C, u00506, "aws__net__ssl__certificate__implB");
   u00507 : constant Version_32 := 16#756f6129#;
   pragma Export (C, u00507, "aws__net__ssl__certificate__implS");
   u00508 : constant Version_32 := 16#04cd36f3#;
   pragma Export (C, u00508, "aws__net__websocket__registry__watchB");
   u00509 : constant Version_32 := 16#cb08cdbe#;
   pragma Export (C, u00509, "aws__net__websocket__registry__watchS");
   u00510 : constant Version_32 := 16#6b6099f3#;
   pragma Export (C, u00510, "aws__server__get_statusB");
   u00511 : constant Version_32 := 16#6092b058#;
   pragma Export (C, u00511, "aws__server__get_statusS");
   u00512 : constant Version_32 := 16#1090f8b1#;
   pragma Export (C, u00512, "aws__server__statusB");
   u00513 : constant Version_32 := 16#ad90675e#;
   pragma Export (C, u00513, "aws__server__statusS");
   u00514 : constant Version_32 := 16#a7ea3a69#;
   pragma Export (C, u00514, "aws__hotplug__get_statusB");
   u00515 : constant Version_32 := 16#6cd9a1b4#;
   pragma Export (C, u00515, "aws__hotplug__get_statusS");
   u00516 : constant Version_32 := 16#000a4849#;
   pragma Export (C, u00516, "aws__server__logB");
   u00517 : constant Version_32 := 16#55f7c516#;
   pragma Export (C, u00517, "aws__server__logS");
   u00518 : constant Version_32 := 16#c5b0117c#;
   pragma Export (C, u00518, "aws__templatesS");
   u00519 : constant Version_32 := 16#95e07aec#;
   pragma Export (C, u00519, "aws__status__setB");
   u00520 : constant Version_32 := 16#4579bade#;
   pragma Export (C, u00520, "aws__status__setS");
   u00521 : constant Version_32 := 16#e27e1dbb#;
   pragma Export (C, u00521, "aws__servicesS");
   u00522 : constant Version_32 := 16#b6cbcebb#;
   pragma Export (C, u00522, "aws__services__transient_pagesB");
   u00523 : constant Version_32 := 16#5fe8bd5b#;
   pragma Export (C, u00523, "aws__services__transient_pagesS");
   u00524 : constant Version_32 := 16#83127e75#;
   pragma Export (C, u00524, "ada__real_time__delaysB");
   u00525 : constant Version_32 := 16#6becaccd#;
   pragma Export (C, u00525, "ada__real_time__delaysS");
   u00526 : constant Version_32 := 16#49ac5009#;
   pragma Export (C, u00526, "aws__services__transient_pages__controlB");
   u00527 : constant Version_32 := 16#6950d8ce#;
   pragma Export (C, u00527, "aws__services__transient_pages__controlS");
   u00528 : constant Version_32 := 16#124ac81a#;
   pragma Export (C, u00528, "aws__session__controlB");
   u00529 : constant Version_32 := 16#e6a27aeb#;
   pragma Export (C, u00529, "aws__session__controlS");
   u00530 : constant Version_32 := 16#7d3544fd#;
   pragma Export (C, u00530, "aws__status__translate_setB");
   u00531 : constant Version_32 := 16#d0739b66#;
   pragma Export (C, u00531, "aws__status__translate_setS");
   u00532 : constant Version_32 := 16#ad61f0f9#;
   pragma Export (C, u00532, "aws__exceptionsS");
   u00533 : constant Version_32 := 16#8be0c330#;
   pragma Export (C, u00533, "aws__net__acceptorsB");
   u00534 : constant Version_32 := 16#b931be2f#;
   pragma Export (C, u00534, "aws__net__acceptorsS");
   u00535 : constant Version_32 := 16#b0aa2dbc#;
   pragma Export (C, u00535, "system__tasking__task_attributesB");
   u00536 : constant Version_32 := 16#65f78b23#;
   pragma Export (C, u00536, "system__tasking__task_attributesS");
   u00537 : constant Version_32 := 16#66f6a412#;
   pragma Export (C, u00537, "soccer__server__callbacksB");
   u00538 : constant Version_32 := 16#211b757c#;
   pragma Export (C, u00538, "soccer__server__callbacksS");
   u00539 : constant Version_32 := 16#1301e8d4#;
   pragma Export (C, u00539, "system__direct_ioB");
   u00540 : constant Version_32 := 16#646372a9#;
   pragma Export (C, u00540, "system__direct_ioS");
   u00541 : constant Version_32 := 16#d4ff77a8#;
   pragma Export (C, u00541, "soccer__server__websocketsB");
   u00542 : constant Version_32 := 16#6b3ea130#;
   pragma Export (C, u00542, "soccer__server__websocketsS");
   --  BEGIN ELABORATION ORDER
   --  ada%s
   --  ada.characters%s
   --  ada.characters.handling%s
   --  ada.characters.latin_1%s
   --  ada.command_line%s
   --  ada.environment_variables%s
   --  gnat%s
   --  interfaces%s
   --  system%s
   --  gnat.byte_swapping%s
   --  gnat.byte_swapping%b
   --  system.address_operations%s
   --  system.address_operations%b
   --  system.arith_64%s
   --  system.atomic_counters%s
   --  system.atomic_counters%b
   --  system.case_util%s
   --  system.case_util%b
   --  gnat.case_util%s
   --  gnat.case_util%b
   --  system.exn_llf%s
   --  system.exn_llf%b
   --  system.exn_lli%s
   --  system.exn_lli%b
   --  system.float_control%s
   --  system.float_control%b
   --  system.htable%s
   --  system.img_bool%s
   --  system.img_bool%b
   --  system.img_char%s
   --  system.img_char%b
   --  system.img_dec%s
   --  system.img_enum_new%s
   --  system.img_enum_new%b
   --  system.img_int%s
   --  system.img_int%b
   --  system.img_dec%b
   --  system.img_lld%s
   --  system.img_lli%s
   --  system.img_lli%b
   --  system.img_lld%b
   --  system.img_real%s
   --  system.io%s
   --  system.io%b
   --  system.linux%s
   --  system.machine_code%s
   --  system.multiprocessors%s
   --  system.os_primitives%s
   --  system.os_primitives%b
   --  system.parameters%s
   --  system.parameters%b
   --  system.crtl%s
   --  interfaces.c_streams%s
   --  interfaces.c_streams%b
   --  system.powten_table%s
   --  system.restrictions%s
   --  system.restrictions%b
   --  system.standard_library%s
   --  system.exceptions_debug%s
   --  system.exceptions_debug%b
   --  system.storage_elements%s
   --  system.storage_elements%b
   --  system.stack_checking%s
   --  system.stack_checking%b
   --  system.stack_checking.operations%s
   --  system.stack_usage%s
   --  system.stack_usage%b
   --  system.string_hash%s
   --  system.string_hash%b
   --  system.htable%b
   --  system.strings%s
   --  system.strings%b
   --  system.traceback_entries%s
   --  system.traceback_entries%b
   --  ada.exceptions%s
   --  system.arith_64%b
   --  ada.exceptions.is_null_occurrence%s
   --  ada.exceptions.is_null_occurrence%b
   --  system.soft_links%s
   --  system.stack_checking.operations%b
   --  system.traces%s
   --  system.traces%b
   --  system.unsigned_types%s
   --  system.fat_flt%s
   --  system.fat_lflt%s
   --  system.fat_llf%s
   --  system.img_biu%s
   --  system.img_biu%b
   --  system.img_llb%s
   --  system.img_llb%b
   --  system.img_llu%s
   --  system.img_llu%b
   --  system.img_llw%s
   --  system.img_llw%b
   --  system.img_uns%s
   --  system.img_uns%b
   --  system.img_real%b
   --  system.img_wiu%s
   --  system.img_wiu%b
   --  system.val_bool%s
   --  system.val_enum%s
   --  system.val_int%s
   --  system.val_lli%s
   --  system.val_llu%s
   --  system.val_real%s
   --  system.val_uns%s
   --  system.val_util%s
   --  system.val_util%b
   --  system.val_uns%b
   --  system.val_real%b
   --  system.val_llu%b
   --  system.val_lli%b
   --  system.val_int%b
   --  system.val_enum%b
   --  system.val_bool%b
   --  system.wch_con%s
   --  system.wch_con%b
   --  system.wch_cnv%s
   --  system.wch_jis%s
   --  system.wch_jis%b
   --  system.wch_cnv%b
   --  system.wch_stw%s
   --  system.wch_stw%b
   --  ada.exceptions.last_chance_handler%s
   --  ada.exceptions.last_chance_handler%b
   --  system.address_image%s
   --  system.bit_ops%s
   --  system.bit_ops%b
   --  system.compare_array_unsigned_8%s
   --  system.compare_array_unsigned_8%b
   --  system.concat_2%s
   --  system.concat_2%b
   --  system.concat_3%s
   --  system.concat_3%b
   --  system.concat_4%s
   --  system.concat_4%b
   --  system.concat_5%s
   --  system.concat_5%b
   --  system.concat_6%s
   --  system.concat_6%b
   --  system.concat_7%s
   --  system.concat_7%b
   --  system.exception_table%s
   --  system.exception_table%b
   --  ada.containers%s
   --  ada.containers.hash_tables%s
   --  ada.containers.prime_numbers%s
   --  ada.containers.prime_numbers%b
   --  ada.containers.red_black_trees%s
   --  ada.io_exceptions%s
   --  ada.numerics%s
   --  ada.numerics.aux%s
   --  ada.numerics.aux%b
   --  ada.numerics.long_elementary_functions%s
   --  ada.numerics.long_elementary_functions%b
   --  ada.strings%s
   --  ada.strings.hash%s
   --  ada.strings.hash%b
   --  ada.strings.hash_case_insensitive%s
   --  ada.strings.maps%s
   --  ada.strings.fixed%s
   --  ada.strings.maps.constants%s
   --  ada.strings.search%s
   --  ada.strings.search%b
   --  ada.tags%s
   --  ada.streams%s
   --  interfaces.c%s
   --  system.multiprocessors%b
   --  interfaces.c.strings%s
   --  system.crtl.runtime%s
   --  system.exceptions%s
   --  system.exceptions%b
   --  system.finalization_root%s
   --  system.finalization_root%b
   --  ada.finalization%s
   --  ada.finalization%b
   --  system.os_constants%s
   --  system.os_interface%s
   --  system.os_interface%b
   --  system.interrupt_management%s
   --  system.regpat%s
   --  gnat.regpat%s
   --  system.storage_pools%s
   --  system.storage_pools%b
   --  system.finalization_masters%s
   --  system.storage_pools.subpools%s
   --  system.stream_attributes%s
   --  system.stream_attributes%b
   --  system.task_info%s
   --  system.task_info%b
   --  system.task_primitives%s
   --  system.interrupt_management%b
   --  system.tasking%s
   --  ada.task_identification%s
   --  system.task_primitives.operations%s
   --  system.tasking%b
   --  system.tasking.debug%s
   --  system.tasking.debug%b
   --  system.task_primitives.operations%b
   --  system.traces.tasking%s
   --  system.traces.tasking%b
   --  ada.calendar%s
   --  ada.calendar%b
   --  ada.calendar.delays%s
   --  ada.calendar.delays%b
   --  ada.calendar.time_zones%s
   --  ada.calendar.time_zones%b
   --  ada.calendar.formatting%s
   --  gnat.calendar%s
   --  gnat.calendar%b
   --  gnat.calendar.time_io%s
   --  gnat.secure_hashes%s
   --  gnat.secure_hashes%b
   --  gnat.secure_hashes.md5%s
   --  gnat.secure_hashes.md5%b
   --  gnat.md5%s
   --  gnat.md5%b
   --  gnat.secure_hashes.sha1%s
   --  gnat.secure_hashes.sha1%b
   --  gnat.sha1%s
   --  gnat.sha1%b
   --  system.communication%s
   --  system.communication%b
   --  system.memory%s
   --  system.memory%b
   --  system.standard_library%b
   --  system.pool_global%s
   --  system.pool_global%b
   --  gnat.sockets%s
   --  gnat.sockets.constants%s
   --  gnat.sockets.linker_options%s
   --  system.file_control_block%s
   --  ada.streams.stream_io%s
   --  system.direct_io%s
   --  system.file_io%s
   --  system.direct_io%b
   --  ada.streams.stream_io%b
   --  system.pool_size%s
   --  system.pool_size%b
   --  system.random_numbers%s
   --  system.random_seed%s
   --  system.random_seed%b
   --  system.secondary_stack%s
   --  system.storage_pools.subpools%b
   --  system.finalization_masters%b
   --  system.regpat%b
   --  interfaces.c.strings%b
   --  interfaces.c%b
   --  ada.tags%b
   --  ada.strings.fixed%b
   --  ada.strings.maps%b
   --  ada.strings.hash_case_insensitive%b
   --  system.soft_links%b
   --  ada.environment_variables%b
   --  ada.command_line%b
   --  ada.characters.handling%b
   --  system.secondary_stack%b
   --  system.random_numbers%b
   --  ada.calendar.formatting%b
   --  system.address_image%b
   --  ada.strings.unbounded%s
   --  ada.strings.unbounded%b
   --  ada.directories%s
   --  ada.directories.validity%s
   --  ada.directories.validity%b
   --  gnat.decode_utf8_string%s
   --  gnat.decode_utf8_string%b
   --  gnat.encode_utf8_string%s
   --  gnat.encode_utf8_string%b
   --  gnat.sockets.thin_common%s
   --  gnat.sockets.thin_common%b
   --  system.os_lib%s
   --  system.os_lib%b
   --  system.file_io%b
   --  gnat.os_lib%s
   --  gnat.sockets.thin%s
   --  system.regexp%s
   --  system.regexp%b
   --  ada.directories%b
   --  gnat.regexp%s
   --  system.soft_links.tasking%s
   --  system.soft_links.tasking%b
   --  system.strings.stream_ops%s
   --  system.strings.stream_ops%b
   --  system.task_lock%s
   --  system.task_lock%b
   --  gnat.sockets%b
   --  gnat.task_lock%s
   --  gnat.sockets.thin%b
   --  system.tasking.entry_calls%s
   --  system.tasking.initialization%s
   --  system.tasking.initialization%b
   --  system.tasking.protected_objects%s
   --  system.tasking.protected_objects%b
   --  system.tasking.task_attributes%s
   --  system.tasking.task_attributes%b
   --  system.tasking.utilities%s
   --  ada.task_identification%b
   --  system.traceback%s
   --  ada.exceptions%b
   --  system.traceback%b
   --  ada.real_time%s
   --  ada.real_time%b
   --  ada.real_time.delays%s
   --  ada.real_time.delays%b
   --  ada.text_io%s
   --  ada.text_io%b
   --  gnat.calendar.time_io%b
   --  ada.text_io.c_streams%s
   --  ada.text_io.c_streams%b
   --  ada.text_io.float_aux%s
   --  ada.text_io.generic_aux%s
   --  ada.text_io.generic_aux%b
   --  ada.text_io.float_aux%b
   --  ada.text_io.integer_aux%s
   --  ada.text_io.integer_aux%b
   --  ada.integer_text_io%s
   --  ada.integer_text_io%b
   --  system.tasking.protected_objects.entries%s
   --  system.tasking.protected_objects.entries%b
   --  system.tasking.queuing%s
   --  system.tasking.queuing%b
   --  system.tasking.utilities%b
   --  system.tasking.rendezvous%s
   --  system.tasking.protected_objects.operations%s
   --  system.tasking.protected_objects.operations%b
   --  system.tasking.rendezvous%b
   --  system.tasking.entry_calls%b
   --  system.tasking.stages%s
   --  system.tasking.stages%b
   --  aws%s
   --  aws.containers%s
   --  aws.default%s
   --  aws.services%s
   --  gnatcoll%s
   --  ssl%s
   --  aws.containers.key_value%s
   --  aws.containers.key_value%b
   --  aws.containers.string_vectors%s
   --  aws.containers.string_vectors%b
   --  aws.config%s
   --  aws.config.ini%s
   --  aws.config%b
   --  aws.config.set%s
   --  aws.config.utils%s
   --  aws.containers.tables%s
   --  aws.containers.tables%b
   --  aws.containers.tables.set%s
   --  aws.containers.tables.set%b
   --  aws.digest%s
   --  aws.messages%s
   --  aws.mime%s
   --  aws.os_lib%s
   --  aws.parameters%s
   --  aws.parameters%b
   --  aws.url%s
   --  aws.url.raise_url_error%s
   --  aws.url.raise_url_error%b
   --  aws.url.set%s
   --  gnatcoll.json%s
   --  gnatcoll.json.utility%s
   --  gnatcoll.json.utility%b
   --  gnatcoll.json%b
   --  memory_streams%s
   --  memory_streams%b
   --  soccer%s
   --  soccer%b
   --  soccer.core_event%s
   --  soccer.core_event.game_core_event%s
   --  soccer.core_event.game_core_event.binary_game_event%s
   --  soccer.core_event.game_core_event.binary_game_event%b
   --  soccer.core_event.game_core_event.match_game_event%s
   --  soccer.core_event.game_core_event.match_game_event%b
   --  soccer.core_event.game_core_event.unary_game_event%s
   --  soccer.core_event.game_core_event.unary_game_event%b
   --  soccer.core_event.motion_core_event%s
   --  soccer.core_event.motion_core_event%b
   --  soccer.controllerpkg%s
   --  soccer.core_event.motion_core_event.catch_motion_event%s
   --  soccer.core_event.motion_core_event.move_motion_event%s
   --  soccer.core_event.motion_core_event.shot_motion_event%s
   --  soccer.core_event.motion_core_event.shot_motion_event%b
   --  soccer.core_event.motion_core_event.tackle_motion_event%s
   --  soccer.core_event.motion_core_event.tackle_motion_event%b
   --  soccer.field_event%s
   --  soccer.field_event%b
   --  soccer.manager_event%s
   --  soccer.manager_event%b
   --  soccer.manager_event.formation%s
   --  soccer.manager_event.formation%b
   --  soccer.manager_event.substitution%s
   --  soccer.manager_event.substitution%b
   --  soccer.bridge%s
   --  soccer.bridge%b
   --  soccer.playerspkg%s
   --  soccer.server%s
   --  soccer.utils%s
   --  soccer.utils%b
   --  soccer.playerspkg%b
   --  soccer.controllerpkg%b
   --  ssl.thin%s
   --  templates_parser_tasking%s
   --  templates_parser_tasking%b
   --  templates_parser%s
   --  aws.templates%s
   --  templates_parser.input%s
   --  templates_parser.utils%s
   --  templates_parser.utils%b
   --  zlib%s
   --  aws.utils%s
   --  aws.utils%b
   --  aws.config.set%b
   --  aws.config.ini%b
   --  aws.containers.memory_streams%s
   --  aws.containers.memory_streams%b
   --  aws.net%s
   --  aws.headers%s
   --  aws.attachments%s
   --  aws.headers.set%s
   --  aws.headers.values%s
   --  aws.headers.values%b
   --  aws.messages%b
   --  aws.net.buffered%s
   --  aws.headers.set%b
   --  aws.headers%b
   --  aws.config.utils%b
   --  aws.net.generic_sets%s
   --  aws.net.generic_sets%b
   --  aws.net.log%s
   --  aws.net.log%b
   --  aws.net.poll_events%s
   --  aws.net.poll_events%b
   --  aws.net.std%s
   --  aws.net.std%b
   --  aws.net.ssl%s
   --  aws.net.ssl%b
   --  aws.net%b
   --  aws.net.ssl.certificate%s
   --  aws.net.ssl.certificate.impl%s
   --  aws.net.ssl.certificate.impl%b
   --  aws.net.ssl.certificate%b
   --  aws.parameters.set%s
   --  aws.url.set%b
   --  aws.resources%s
   --  templates_parser.input%b
   --  aws.resources.files%s
   --  aws.resources.streams%s
   --  aws.resources.streams%b
   --  aws.resources.streams.disk%s
   --  aws.resources.streams.disk%b
   --  aws.resources.streams.disk.once%s
   --  aws.resources.streams.disk.once%b
   --  aws.resources.streams.memory%s
   --  aws.resources.streams.memory%b
   --  aws.resources.embedded%s
   --  aws.resources%b
   --  aws.resources.streams.memory.zlib%s
   --  aws.resources.streams.memory.zlib%b
   --  aws.resources.streams.zlib%s
   --  aws.resources.streams.zlib%b
   --  aws.resources.embedded%b
   --  aws.resources.files%b
   --  aws.services.transient_pages%s
   --  aws.services.transient_pages%b
   --  aws.services.transient_pages.control%s
   --  aws.services.transient_pages.control%b
   --  aws.translator%s
   --  aws.translator%b
   --  aws.attachments%b
   --  aws.utils.streams%s
   --  aws.utils.streams%b
   --  templates_parser.configuration%s
   --  templates_parser%b
   --  zlib.thin%s
   --  zlib.thin%b
   --  zlib%b
   --  aws.net.buffered%b
   --  aws.url%b
   --  aws.mime%b
   --  aws.digest%b
   --  aws.net.acceptors%s
   --  aws.net.acceptors%b
   --  aws.session%s
   --  aws.session%b
   --  aws.session.control%s
   --  aws.session.control%b
   --  aws.status%s
   --  aws.status%b
   --  aws.net.websocket%s
   --  aws.net.websocket.protocol%s
   --  aws.net.websocket.protocol.draft76%s
   --  aws.net.websocket.protocol.draft76%b
   --  aws.net.websocket.protocol.rfc6455%s
   --  aws.net.websocket.protocol.rfc6455%b
   --  aws.net.websocket%b
   --  aws.net.websocket.registry%s
   --  aws.net.websocket.registry%b
   --  aws.net.websocket.registry.control%s
   --  aws.net.websocket.registry.control%b
   --  aws.net.websocket.registry.watch%s
   --  aws.net.websocket.registry.watch%b
   --  aws.response%s
   --  aws.client%s
   --  aws.client.http_utils%s
   --  aws.client%b
   --  aws.dispatchers%s
   --  aws.dispatchers%b
   --  aws.dispatchers.callback%s
   --  aws.dispatchers.callback%b
   --  aws.hotplug%s
   --  aws.hotplug%b
   --  aws.hotplug.get_status%s
   --  aws.hotplug.get_status%b
   --  aws.log%s
   --  aws.log%b
   --  aws.exceptions%s
   --  aws.response.set%s
   --  aws.response.set%b
   --  aws.client.http_utils%b
   --  aws.response%b
   --  aws.server%s
   --  aws.parameters.set%b
   --  aws.server.get_status%s
   --  aws.server.http_utils%s
   --  aws.server.log%s
   --  aws.server.log%b
   --  aws.server.status%s
   --  aws.server.status%b
   --  aws.server.get_status%b
   --  aws.status.set%s
   --  aws.status.set%b
   --  aws.server.http_utils%b
   --  aws.status.translate_set%s
   --  aws.status.translate_set%b
   --  aws.server%b
   --  soccer.server.callbacks%s
   --  soccer.server.callbacks%b
   --  soccer.server.websockets%s
   --  soccer.server.websockets%b
   --  soccer.server.webserver%s
   --  soccer.server.webserver%b
   --  soccer.main%b
   --  END ELABORATION ORDER


end ada_main;
