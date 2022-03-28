// ignore: file_names
import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:petzone/bloc/registerProfile/register_profile_bloc.dart';
import 'package:petzone/model/UserRegister.dart';
import 'package:petzone/repositories/admin_repository.dart';
import 'package:petzone/widgets/custom_dialog.dart';
import 'package:petzone/widgets/profile.dart';
import '../../widgets/custom_button.dart';
import '../../constants.dart';
import '../../widgets/slide/slide_dots.dart';
import 'admin_register_list.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;

class RegisterRequestView extends StatefulWidget {
  final User user;

  const RegisterRequestView({Key? key, required this.user}) : super(key: key);
  @override
  State<StatefulWidget> createState() => RegisterRequestViewState();
}

class RegisterRequestViewState extends State<RegisterRequestView> {
  late User user;
  String? pathPDF;
  final Completer<PDFViewController> _controller =
      Completer<PDFViewController>();
  final Completer<PDFViewController> _dialogController =
      Completer<PDFViewController>();
  int? pages = 0;
  int? currentPage = 0;
  bool isReady = true;
  String errorMessage = '';
  bool degreeImg = true;

  Future<File> createFileOfPdfUrl(String url) async {
    Completer<File> completer = Completer();
    print("Start download file from internet!");
    try {
      // final url = "https://pdfkit.org/docs/guide.pdf";
      final filename = url.substring(url.lastIndexOf("/") + 1);
      var request = await HttpClient().getUrl(Uri.parse(url));
      var response = await request.close();
      var bytes = await consolidateHttpClientResponseBytes(response);
      var dir = await getApplicationDocumentsDirectory().then((value) {
        print(value.path);
        return value;
      });
      print("Download files");
      print("${dir.path}/$filename");
      File file = File("${dir.path}/$filename");
      await file.writeAsBytes(bytes, flush: true);
      completer.complete(file);
    } catch (e) {
      throw Exception('Error parsing asset file!');
    }

    return completer.future;
  }

  @override
  void initState() {
    super.initState();
    user = widget.user;
    if (user is Vet) {
      if ((user as Vet).degree.contains('.pdf')) {
        setState(() {
          degreeImg = false;
          isReady = false;
        });
        requestPersmission();
      }
    }
  }

  requestPersmission() async {
    PermissionStatus result = await Permission.storage.request();
    if (result.isGranted) {
      createFileOfPdfUrl((user as Vet).degree).then((f) {
        setState(() {
          pathPDF = f.path;
        });
      });
    } else
      Navigator.pop(context);
  }

  AdminRepository adminRepository = AdminRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (_) => RegisterProfileBloc(adminRepository: adminRepository),
        child: Scaffold(
            appBar: AppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Colors.teal[800],
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            body: Stack(
              alignment: Alignment.center,
              children: [
                CustomPaint(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                  ),
                  painter: HeaderCurvedContainer(),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 35,
                            letterSpacing: 1.5,
                            color: TextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                      Container(
                        padding: EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width / 2,
                        height: MediaQuery.of(context).size.width / 3.5,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 5),
                          shape: BoxShape.circle,
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.contain,
                            image: user.photo == null
                                ? AssetImage("assets/defaultpfp.png")
                                : Image.network(user.photo!).image,
                          ),
                        ),
                      ),

// Tab Number? text?, and

                      if (user is Vet)
                        CustomTabBar(
                          tabs: [Tab(text: 'Bio'), Tab(text: 'Degree')],
                          tabView: [
                            Column(children: <Widget>[
                              ListTile(
                                title: Text('Email:'),
                                subtitle: Text(user.email),
                              ),
                              ListTile(
                                title: Text('Phone Number:'),
                                subtitle: Text(user.phone),
                              ),
                              ListTile(
                                title: Text('Specialty:'),
                                subtitle: Text((user as Vet).specialty),
                              ),
                              ListTile(
                                title: Text('Experience:'),
                                subtitle: Text((user as Vet).experience),
                              ),
                            ]),
                            Column(children: <Widget>[
                              // FullScreenImage(String)
                              degreeImg
                                  ? GestureDetector(
                                      onTap: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                FullScreenImage(
                                              imageUrl: (user as Vet).degree,
                                              tag: 'degree',
                                            ),
                                          )),
                                      child:
                                          Image.network((user as Vet).degree))
                                  : pathPDF == null
                                      ? LinearProgressIndicator()
                                      : Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.35,
                                          child: PDFView(
                                            filePath: pathPDF,
                                            autoSpacing: false,
                                            pageFling: true,
                                            pageSnap: true,
                                            defaultPage: currentPage!,
                                            fitPolicy: FitPolicy.BOTH,
                                            preventLinkNavigation:
                                                false, // if set to true the link is handled in flutter
                                            onRender: (_pages) {
                                              setState(() {
                                                pages = _pages;
                                                isReady = true;
                                              });
                                            },
                                            onError: (error) {
                                              setState(() {
                                                errorMessage = error.toString();
                                              });
                                              print(error.toString());
                                            },
                                            onPageError: (page, error) {
                                              setState(() {
                                                errorMessage =
                                                    '$page: ${error.toString()}';
                                              });
                                              print(
                                                  '$page: ${error.toString()}');
                                            },
                                            onViewCreated: (PDFViewController
                                                pdfViewController) {
                                              _controller
                                                  .complete(pdfViewController);
                                            },
                                            onLinkHandler: (String? uri) {
                                              print('goto uri: $uri');
                                            },
                                            onPageChanged:
                                                (int? page, int? total) {
                                              print(
                                                  'page change: $page/$total');
                                              setState(() {
                                                currentPage = page;
                                              });
                                            },
                                          )),

                              if (pathPDF != null)
                                InkWell(
                                    onTap: () {
                                      if (pathPDF != null) showPDF();
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      color: Colors.black45,
                                      child: Row(
                                        children: [
                                          Icon(Icons.fullscreen),
                                          Text('Fullscreen ')
                                        ],
                                      ),
                                    )),

                              errorMessage.isEmpty
                                  ? !isReady
                                      ? Center(
                                          child: LinearProgressIndicator(),
                                        )
                                      : Container()
                                  : Center(
                                      child: Text(errorMessage),
                                    )
                            ])
                          ],
                        ),

                      if (user is Org)
                        SingleChildScrollView(
                          child: Column(children: <Widget>[
                            ListTile(
                              title: Text('Email:',
                                  style: TextStyle(fontSize: 18)),
                              subtitle: Text(user.email,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            ListTile(
                              title: Text('Phone Number:',
                                  style: TextStyle(fontSize: 18)),
                              subtitle: Text(user.phone,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            ListTile(
                              title:
                                  Text('City:', style: TextStyle(fontSize: 18)),
                              subtitle: Text((user as Org).location,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            ListTile(
                              title: Text('Website:',
                                  style: TextStyle(fontSize: 18)),
                              subtitle: Text((user as Org).website,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            ListTile(
                              title: Text('Licensing Number:',
                                  style: TextStyle(fontSize: 18)),
                              subtitle: Text((user as Org).license,
                                  style: TextStyle(fontSize: 18)),
                            ),
                            ListTile(
                              title: Text('Description:',
                                  style: TextStyle(fontSize: 18)),
                              subtitle: Text((user as Org).description,
                                  style: TextStyle(fontSize: 18)),
                            ),
                          ]),
                        ),

                      ButtonBar(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          CustomButton(
                              text: 'Disapprove',
                              textSize: 18,
                              textColor: Colors.white,
                              color: DeclineButton,
                              size: Size(
                                  MediaQuery.of(context).size.width * 0.35, 50),
                              pressed: () {
                                showDialog(
                                  barrierColor: Colors.black26,
                                  context: context,
                                  builder: (context) {
                                    return CustomAlertDialog(
                                      title: "Disapprove User",
                                      description:
                                          "Are you sure you want to reject this user?",
                                      optionOne: 'Disapprove',
                                      optionTwo: 'Cancel',
                                      pressed: () {
                                        BlocProvider.of<RegisterProfileBloc>(
                                                this.context)
                                            .add(DisapproveUserEvent(user));
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: const Text(
                                              'The user has been rejected successfully'),
                                          backgroundColor: Colors.grey,
                                        ));
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                RegisterRequestList(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                );
                              }),
                          SizedBox(width: 10),
                          CustomButton(
                              text: 'Approve',
                              textSize: 18,
                              textColor: Colors.white,
                              color: AcceptButton,
                              size: Size(
                                  MediaQuery.of(context).size.width * 0.3, 50),
                              pressed: () {
                                showDialog(
                                    barrierColor: Colors.black26,
                                    context: context,
                                    builder: (context) {
                                      return CustomAlertDialog(
                                        title: "Approve User",
                                        description:
                                            "Are you sure you want to approve this user? ",
                                        optionOne: 'Approve',
                                        optionTwo: 'Cancel',
                                        pressed: () {
                                          BlocProvider.of<RegisterProfileBloc>(
                                                  context)
                                              .add(ApproveUserEvent(user));
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(SnackBar(
                                            content: const Text(
                                                'The user has been approved successfully'),
                                            backgroundColor: Colors.green,
                                          ));
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) =>
                                                  RegisterRequestList(),
                                            ),
                                          );
                                        },
                                      );
                                    });
                              })
                        ],
                      )
                    ],
                  ),
                )
              ],
            )));
  }

  showPDF() {
    Dialog dialog = Dialog(
        elevation: 0,
        backgroundColor: Colors.black,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: SingleChildScrollView(
            child: Container(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Container(
                    height: 500,
                    width: 500,
                    child: PDFView(
                      filePath: pathPDF,
                      enableSwipe: true,
                      swipeHorizontal: true,
                      autoSpacing: false,
                      pageFling: true,
                      pageSnap: true,
                      defaultPage: currentPage!,
                      fitPolicy: FitPolicy.BOTH,
                      preventLinkNavigation:
                          false, // if set to true the link is handled in flutter
                      onRender: (_pages) {
                        setState(() {
                          pages = _pages;
                          isReady = true;
                        });
                      },
                      onError: (error) {
                        setState(() {
                          errorMessage = error.toString();
                        });
                        print(error.toString());
                      },
                      onPageError: (page, error) {
                        setState(() {
                          errorMessage = '$page: ${error.toString()}';
                        });
                        print('$page: ${error.toString()}');
                      },
                      onViewCreated: (PDFViewController pdfViewController) {
                        _dialogController.complete(pdfViewController);
                      },
                      onLinkHandler: (String? uri) {
                        print('goto uri: $uri');
                      },
                      onPageChanged: (int? page, int? total) {
                        print('page change: $page/$total');
                        setState(() {
                          currentPage = page;
                        });
                      },
                    )))));
    showDialog(context: context, builder: (BuildContext context) => dialog);
  }

  /*



   */

}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Color(0xffD0F1EB);
    Path path = Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width / 2, 100, size.width, 140)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class FullScreenImage extends StatelessWidget {
  final String imageUrl;
  final String tag;

  const FullScreenImage({Key? key, required this.imageUrl, required this.tag})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: tag,
            child: Image(
                width: MediaQuery.of(context).size.width,
                fit: BoxFit.contain,
                image: Image.network(imageUrl).image),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
