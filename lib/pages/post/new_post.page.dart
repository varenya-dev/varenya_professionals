import 'dart:io';

import 'package:flutter/material.dart';
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
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/utils/upload_image_generate_url.dart';
import 'package:varenya_professionals/widgets/common/custom_text_area.widget.dart';
import 'package:varenya_professionals/widgets/posts/file_image_carousel.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_categories.widget.dart';

class NewPost extends StatefulWidget {
  const NewPost({Key? key}) : super(key: key);

  static const routeName = "/new-post";

  @override
  _NewPostState createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late final PostService _postService;
  final TextEditingController _bodyController = new TextEditingController();
  List<PostCategory> _categories = [];
  List<File> _imageFiles = [];

  @override
  void initState() {
    super.initState();

    this._postService = Provider.of<PostService>(context, listen: false);
  }

  @override
  void dispose() {
    super.dispose();

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
        "Profile picture updated!",
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
        body: body,
        images: uploadedImages,
        categories: selectedCategories,
      );

      await this._postService.createNewPost(createPostDto);

      displaySnackbar("Post Created!", context);

      Navigator.of(context).pop();
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
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

  void _openPostCategories() {
    displayBottomSheet(
      context,
      StatefulBuilder(
        builder: (context, setStateInner) => Wrap(
          children: [
            FutureBuilder(
              future: this._postService.fetchCategories(),
              builder: (BuildContext context,
                  AsyncSnapshot<List<PostCategory>> snapshot) {
                if (snapshot.hasError) {
                  switch (snapshot.error.runtimeType) {
                    case ServerException:
                      {
                        ServerException exception =
                            snapshot.error as ServerException;
                        return Text(exception.message);
                      }
                    default:
                      {
                        log.e(
                          "NewPost Error",
                          snapshot.error,
                          snapshot.stackTrace,
                        );
                        return Text(
                            "Something went wrong, please try again later");
                      }
                  }
                }

                if (snapshot.connectionState == ConnectionState.done) {
                  List<PostCategory> fetchedCategories = snapshot.data!;
                  return ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: fetchedCategories
                        .map(
                          (category) => ListTile(
                            title: Text(
                              category.categoryName,
                            ),
                            leading: Checkbox(
                              value: this
                                  ._categories
                                  .where((cty) => cty.id == category.id)
                                  .isNotEmpty,
                              onChanged: (bool? value) {
                                if (value == true) {
                                  setState(() {
                                    this._categories.add(category);
                                  });
                                } else {
                                  setState(() {
                                    this._categories = this
                                        ._categories
                                        .where((cty) => cty.id != category.id)
                                        .toList();
                                  });
                                }
                                setStateInner(() {});
                              },
                            ),
                          ),
                        )
                        .toList(),
                  );
                }

                return Column(
                  children: [
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Center(
              child: TextButton(
                child: Text('Clear Filters'),
                onPressed: () {
                  setState(() {
                    this._categories.clear();
                  });

                  setStateInner(() {});
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Post'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: this._formKey,
          child: Column(
            children: [
              CustomTextArea(
                textFieldController: this._bodyController,
                label: 'Body of the post',
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
                minLines: 1,
              ),
              TextButton(
                onPressed: this._openPostCategories,
                child: Text(
                  'Select Categories',
                ),
              ),
              PostCategories(
                categories: this._categories,
              ),
              TextButton(
                onPressed: this._onUploadImage,
                child: Text(
                  'Upload Images',
                ),
              ),
              FileImageCarousel(
                fileImages: this._imageFiles,
                onDelete: this._removeImage,
              ),
              TextButton(
                onPressed: this._onCreateNewPost,
                child: Text(
                  'Create Post',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
