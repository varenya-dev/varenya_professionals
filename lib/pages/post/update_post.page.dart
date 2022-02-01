import 'dart:io';

import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:varenya_professionals/dtos/post/update_post/update_post.dto.dart';
import 'package:varenya_professionals/exceptions/server.exception.dart';
import 'package:varenya_professionals/models/post/post.model.dart';
import 'package:varenya_professionals/models/post/post_category/post_category.model.dart';
import 'package:varenya_professionals/services/post.service.dart';
import 'package:varenya_professionals/utils/display_bottom_sheet.dart';
import 'package:varenya_professionals/utils/image_picker.dart';
import 'package:varenya_professionals/utils/logger.util.dart';
import 'package:varenya_professionals/utils/snackbar.dart';
import 'package:varenya_professionals/utils/upload_image_generate_url.dart';
import 'package:varenya_professionals/widgets/common/custom_text_area.widget.dart';
import 'package:varenya_professionals/widgets/posts/mixed_image_carousel.widget.dart';
import 'package:varenya_professionals/widgets/posts/post_categories.widget.dart';

class UpdatePost extends StatefulWidget {
  const UpdatePost({Key? key}) : super(key: key);

  static const routeName = "/update-post";

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  late final PostService _postService;
  Post? _post;
  final TextEditingController _bodyController = new TextEditingController();
  List<PostCategory> _categories = [];
  List<String> _images = [];

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
      setState(() {
        this._images.add(imageXFile.path);
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
      setState(() {
        this._images.add(imageXFile.path);
      });

      // Display a success snackbar.
      displaySnackbar(
        "Image Added",
        context,
      );
    }
  }

  void _removeImage(String image) {
    setState(() {
      this._images = this._images.where((imgFile) => imgFile != image).toList();
    });
  }

  Future<void> _onUpdatePost() async {
    if (!this._formKey.currentState!.validate()) {
      return;
    }
    try {
      List<String> uploadedImages = await Future.wait(
        this._images.map(
          (img) async {
            if (img.startsWith("http")) {
              return img;
            } else {
              return await uploadImageAndGenerateUrl(new File(img), 'posts');
            }
          },
        ),
      );

      List<String> selectedCategories =
          this._categories.map((category) => category.categoryName).toList();

      if (selectedCategories.length == 0) {
        throw new ServerException(
            message: 'Please select at least one category');
      }

      String body = this._bodyController.text;

      UpdatePostDto updatePostDto = new UpdatePostDto(
        title: '',
        id: this._post!.id,
        body: body,
        images: uploadedImages,
        categories: selectedCategories,
      );

      await this._postService.updatePost(updatePostDto);

      displaySnackbar("Post Updated!", context);

      Navigator.of(context).pop();
    } on ServerException catch (error) {
      displaySnackbar(error.message, context);
    } catch (error, stackTrace) {
      log.e("UpdatePost:_onUpdatePost", error, stackTrace);
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
                          "UpdatePost Error",
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
    if (this._post == null) {
      this._post = ModalRoute.of(context)!.settings.arguments as Post;

      setState(() {
        this._bodyController.text = this._post!.body;
        this._images = this._post!.images.map((img) => img.imageUrl).toList();
        this._categories = this._post!.categories;
      });
    }

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
              MixedImageCarousel(
                images: this._images,
                onDelete: this._removeImage,
              ),
              TextButton(
                onPressed: this._onUpdatePost,
                child: Text(
                  'Update Post',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
