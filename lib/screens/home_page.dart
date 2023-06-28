import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive_animation/models/user_model.dart';
import '../blocs/auth_bloc.dart';
import '../services/interceptors/dio_interceptor.dart';
import 'auth/phone_signin/phone_signin.dart';
import 'onboding/onboding_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  late User user;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (context
          .read<AuthBloc>()
          .state is !AuthAuthenticatedState) {
        Future.delayed(Duration.zero, () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          );
        });
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthAuthenticatedState) {
          user = state.user;
          return Scaffold(
            appBar: AppBar(
              title: const Text("EauWise"),
              actions: [
                IconButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(AuthLogoutEvent());
                  },
                  splashRadius: 23,
                  icon: const Icon(
                    Icons.logout,
                  ),
                ),
              ],
            ),
            body: FutureBuilder<List<dynamic>>(
              future: _getData(),
              builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else {
                  //Todo: Here You can retrieve data from using the Dio package
                  return ListView.builder(
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      final item = snapshot.data![index];
                      return ListTile(
                        title: Text(item['firstName']),
                      );
                    },
                  );
                }
              },
            ),
          );
        } else {
          return const PhoneSigninPage();
        }
      },
    );
  }


  Future<List<dynamic>> _getData() async {
    try {
      final response = await Api().get('/api/farmer/all');
      return response.data!;
    } on DioError {
      throw Exception('Failed to load data');
    }
  }
}

