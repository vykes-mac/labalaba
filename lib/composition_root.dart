import 'package:chat/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labalaba/data/datasources/datasource_contract.dart';
import 'package:labalaba/data/datasources/sqflite_datasource.dart';
import 'package:labalaba/data/factories/db_factory.dart';
import 'package:labalaba/data/services/image_uploader.dart';
import 'package:labalaba/states_management/home/chats_cubit.dart';
import 'package:labalaba/states_management/home/home_cubit.dart';
import 'package:labalaba/states_management/message/message_bloc.dart';
import 'package:labalaba/states_management/onboarding/onboarding_cubit.dart';
import 'package:labalaba/states_management/onboarding/profile_image_cubit.dart';
import 'package:labalaba/ui/pages/home/home.dart';
import 'package:labalaba/ui/pages/onboarding/onboarding.dart';
import 'package:labalaba/viewmodels/chats_view_model.dart';
import 'package:rethinkdb_dart/rethinkdb_dart.dart';
import 'package:sqflite/sqflite.dart';

class CompositionRoot {
  static Rethinkdb _r;
  static Connection _connection;
  static IUserService _userService;
  static Database _db;
  static IMessageService _messageService;
  static IDatasource _datasource;

  static configure() async {
    _r = Rethinkdb();
    _connection = await _r.connect(host: '127.0.0.1', port: 28015);
    _userService = UserService(_r, _connection);
    _messageService = MessageService(_r, _connection);
    _db = await LocalDatabaseFactory().createDatabase();
    _datasource = SqfliteDatasource(_db);
    // _db.delete('chats');
    // _db.delete('messages');
  }

  static Widget composeOnboardingUi() {
    ImageUploader imageUploader = ImageUploader('http://localhost:3000/upload');

    OnboardingCubit onboardingCubit =
        OnboardingCubit(_userService, imageUploader);
    ProfileImageCubit imageCubit = ProfileImageCubit();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => onboardingCubit),
        BlocProvider(create: (BuildContext context) => imageCubit),
      ],
      child: Onboarding(),
    );
  }

  static Widget composeHomeUi() {
    HomeCubit homeCubit = HomeCubit(_userService);
    MessageBloc messageBloc = MessageBloc(_messageService);
    ChatsViewModel viewModel = ChatsViewModel(_datasource, _userService);
    ChatsCubit chatsCubit = ChatsCubit(viewModel);

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (BuildContext context) => homeCubit),
        BlocProvider(
          create: (BuildContext context) => messageBloc,
        ),
        BlocProvider(create: (BuildContext context) => chatsCubit)
      ],
      child: Home(),
    );
  }
}
