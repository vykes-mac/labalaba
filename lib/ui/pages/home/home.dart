import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:labalaba/states_management/home/home_cubit.dart';
import 'package:labalaba/states_management/home/home_state.dart';
import 'package:labalaba/ui/widgets/home/active/active_users.dart';
import 'package:labalaba/ui/widgets/home/chats/chats.dart';
import 'package:labalaba/ui/widgets/home/profile_image.dart';

class Home extends StatefulWidget {
  const Home();

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().activeUsers();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Container(
            width: double.maxFinite,
            child: Row(
              children: [
                ProfileImage(
                  imageUrl: "https://picsum.photos/seed/picsum/200/300",
                  online: true,
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Jess',
                        style: Theme.of(context).textTheme.caption.copyWith(
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text('online',
                          style: Theme.of(context).textTheme.caption),
                    ),
                  ],
                )
              ],
            ),
          ),
          bottom: TabBar(
            indicatorPadding: EdgeInsets.only(top: 10.0, bottom: 10.0),
            tabs: [
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text('Messages'),
                  ),
                ),
              ),
              Tab(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<HomeCubit, HomeState>(
                        builder: (_, state) => state is HomeSuccess
                            ? Text('Active(${state.onlineUsers.length})')
                            : Text('Active(0)')),
                  ),
                ),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Chats(),
            ActiveUsers(),
          ],
        ),
      ),
    );
  }
}
