import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'PuzzlePiece.dart';


class PuzzleGame extends StatefulWidget {
  final String title;
  int rows = 3;
  int cols = 3;

  PuzzleGame({Key key, this.title}) : super(key: key);

  @override
  _PuzzleGameState createState() => _PuzzleGameState();
}

class _PuzzleGameState extends State<PuzzleGame> {
  File _image;
  List<Widget> pieces = [];

  Future getImage(ImageSource source) async {
    var image = await ImagePicker.pickImage(source: source);

    if (image != null) {
      setState(() {
        _image = image;
        pieces.clear();
      });

      splitImage(Image.file(image));
    }
  }

  // we need to find out the image size, to be used in the PuzzlePiece widget
  Future<Size> getImageSize(Image image) async {
    final Completer<Size> completer = Completer<Size>();

    image.image
        .resolve(const ImageConfiguration())
        .addListener(ImageStreamListener(
      (ImageInfo info, bool _) {
        completer.complete(Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        ));
      },
    ));

    final Size imageSize = await completer.future;

    return imageSize;
  }

  // here we will split the image into small pieces using the rows and columns defined above; each piece will be added to a stack
  void splitImage(Image image) async {
    Size imageSize = await getImageSize(image);

    for (int x = 0; x < widget.rows; x++) {
      for (int y = 0; y < widget.cols; y++) {
        setState(() {
          pieces.add(PuzzlePiece(
              key: GlobalKey(),
              image: image,
              imageSize: imageSize,
              row: x,
              col: y,
              maxRow: widget.rows,
              maxCol: widget.cols,
              bringToTop: this.bringToTop,
              sendToBack: this.sendToBack));
        });
      }
    }
  }

  // when the pan of a piece starts, we need to bring it to the front of the stack
  void bringToTop(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.add(widget);
    });
  }

  // when a piece reaches its final position, it will be sent to the back of the stack to not get in the way of other, still movable, pieces
  void sendToBack(Widget widget) {
    setState(() {
      pieces.remove(widget);
      pieces.insert(0, widget);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Row(children: [
            Text(
              "Rows:",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<int>(
              onChanged: (value) => setState(() => widget.rows = value),
              value: widget.rows,
              items: menuItemsList(5),
            ),
          ]),
          Row(children: [
            Text(
              "Columns:",
              style: TextStyle(fontSize: 16),
            ),
            DropdownButton<int>(
              onChanged: (value) => setState(() => widget.cols = value),
              value: widget.cols,
              items: menuItemsList(5),
            ),
          ])
        ],
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: new Center(
            child: _image == null
                ? new Text('No image selected.')
                : Stack(children: pieces)),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SafeArea(
                  child: new Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      new ListTile(
                        leading: new Icon(Icons.camera),
                        title: new Text('Camera'),
                        onTap: () {
                          getImage(ImageSource.camera);
                          // this is how you dismiss the modal bottom sheet after making a choice
                          Navigator.pop(context);
                        },
                      ),
                      new ListTile(
                        leading: new Icon(Icons.image),
                        title: new Text('Gallery'),
                        onTap: () {
                          getImage(ImageSource.gallery);
                          // dismiss the modal sheet
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                );
              });
        },
        tooltip: 'New Image',
        child: Icon(Icons.add),
      ),
    );
  }

  List<DropdownMenuItem<int>> menuItemsList(int amount) {
    List<DropdownMenuItem<int>> itemList = [];
    for (var i = 2; i <= amount; i++)
      itemList.add(
        DropdownMenuItem<int>(
          child: Text(
            i.toString(),
            style: TextStyle(
                fontSize: 14, fontFamily: "Georgia", color: Colors.cyanAccent),
          ),
          value: i,
        ),
      );

    return itemList;
  }
}