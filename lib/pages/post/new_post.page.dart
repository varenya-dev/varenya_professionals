import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/post/create_post/create_post.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/image_picker.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/palette.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/utils/upload_image_generate_url.dart';
import 'package:varenya_professionals/widgets/common/custom_text_area.widget.dart';
import 'package:varenya_professionals/widgets/posts/display_categories.widget.dart';
import 'package:varenya_professionals/widgets/posts/file_image_carousel.widget.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  static const routeName = "/new-post";

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late final PostService _postService;
  final TextEditingController _titleController = new TextEditingController();
  final TextEditingController _bodyController = new TextEditingController();
  List<PostCategory> _categories = [];
  List<File> _imageFiles = [];

  bool loading = false;

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

    this._titleController.dispose();
    this._bodyController.dispose();
  }

  /*
   * Method for uploading images from gallery.
   */
  Future<void> _uploadFromGallery() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openGallery();

    // Run if there is an image selected.
    if (imageXFile != null) {
      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      setState(() {
        this._imageFiles.add(imageFile);
      });

      // Display a success snackbar.
      displaySnackbar(
        "Image Added",
        context,
      );
    }
  }

  /*
   * Method for uploading images from camera.
   */
  Future<void> _uploadFromCamera() async {
    // Open the gallery and get the selected image.
    XFile? imageXFile = await openCamera();

    // Run if there is an image selected.
    if (imageXFile != null) {
      // Prepare the file from the selected image.
      File imageFile = new File(imageXFile.path);

      setState(() {
        this._imageFiles.add(imageFile);
      });

      // Display a success snackbar.
      displaySnackbar(
        "Image Added",
        context,
      );
    }
  }

  void _removeImage(File imageFile) {
    setState(() {
      this._imageFiles = this
          ._imageFiles
          .where((imgFile) => imgFile.path != imageFile.path)
          .toList();
    });
  }

  Future<void> _onCreateNewPost() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      List<String> uploadedImages = await Future.wait(
        this._imageFiles.map(
              (file) async => await uploadImageAndGenerateUrl(file, 'posts'),
            ),
      );

      List<String> selectedCategories =
          this._categories.map((category) => category.categoryName).toList();

      if (selectedCategories.length == 0) {
        throw new ServerException(
            message: 'Please select at least one category');
      }

      String body = this._bodyController.text;

      CreatePostDto createPostDto = new CreatePostDto(
        title: this._titleController.text,
        body: body,
        images: uploadedImages,
        categories: selectedCategories,
      );

      await this._postService.createNewPost(createPostDto);

      setState(() {
        loading = false;
      });

      displaySnackbar("Post Created!", context);

      Navigator.of(context).pop();
    } on ServerException catch (error) {
      setState(() {
        loading = false;
      });

      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      setState(() {
        loading = false;
      });

      log.e("NewPost:_onCreateNewPost", error, stackTrace);
      displaySnackbar(
        "Something went wrong, please try again later.",
        context,
      );
    }
  }

  /*
   * Method to open up camera or gallery on user's selection.
   */
  void _onUploadImage() {
    displayBottomSheet(
      context,
      Wrap(
        children: [
          ListTile(
            leading: Icon(Icons.camera_alt_rounded),
            title: Text('Upload from camera'),
            onTap: this._uploadFromCamera,
          ),
          ListTile(
            leading: Icon(Icons.photo_album_sharp),
            title: Text('Upload from storage'),
            onTap: this._uploadFromGallery,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Form(
            key: this._formKey,
            child: Column(
              children: [
                this._imageFiles.length == 0
                    ? GestureDetector(
                        onTap: this._onUploadImage,
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.5,
                          decoration: BoxDecoration(color: Colors.black26),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.photo_camera_back,
                                  size:
                                      MediaQuery.of(context).size.height * 0.2,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Click to add image.',
                                  style: Theme.of(context).textTheme.subtitle1,
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : FileImageCarousel(
                        fileImages: this._imageFiles,
                        onDelete: this._removeImage,
                      ),
                CustomTextArea(
                  textFieldController: this._titleController,
                  helperText: 'Title',
                  validators: [
                    RequiredValidator(
                      errorText: 'Title is required.',
                    ),
                    MinLengthValidator(
                      10,
                      errorText: 'Title should be at least 10 characters long.',
                    )
                  ],
                  textInputType: TextInputType.text,
                  minLines: 1,
                  maxLines: 1,
                ),
                CustomTextArea(
                  textFieldController: this._bodyController,
                  helperText: 'Write Something...',
                  validators: [
                    RequiredValidator(
                      errorText: 'Body is required.',
                    ),
                    MinLengthValidator(
                      10,
                      errorText: 'Body should be at least 10 characters long.',
                    )
                  ],
                  textInputType: TextInputType.text,
                  minLines: 5,
                ),
                DisplayCategories(
                  selectedCategories: this._categories,
                  addOrRemoveCategory: (PostCategory postCategory) {
                    if (this
                        ._categories
                        .where((category) => category.id == postCategory.id)
                        .isEmpty) {
                      setState(() {
                        this._categories.add(postCategory);
                      });
                    } else {
                      setState(() {
                        this._categories.removeWhere(
                            (category) => category.id == postCategory.id);
                      });
                    }
                  },
                ),
                OfflineBuilder(
                  connectivityBuilder:
                      (BuildContext context, ConnectivityResult result, _) {
                    final bool connected = result != ConnectivityResult.none;

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Palette.secondary,
                            borderRadius: BorderRadius.circular(
                              15.0,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: connected ? this._onCreateNewPost : null,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Palette.primary,
                                    borderRadius: BorderRadius.circular(
                                      15.0,
                                    ),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.07,
                                  ),
                                  child: !loading
                                      ? Text(
                                          'Update',
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                      : SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .longestSide *
                                              0.025,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .longestSide *
                                              0.025,
                                          child: CircularProgressIndicator(
                                            color: Colors.black,
                                          ),
                                        ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            0.02,
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            0.07,
                                  ),
                                  child: Text('Cancel'),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                  child: SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
