To enable, check the Rules > Show Image Bloat item.

To see the original image, you can find the unmodified copy stored in Fiddler's Session list (look in the COMMENTS column)

Alternatively, select the modified Session in Fiddler's Web Sessions list, and hit the "R" key to reissue; Fiddler will not modify reissued requests. 
Use the ImageView Inspector to see analysis of the original image. http://blogs.telerik.com/fiddler/posts/14-10-03/hunting-for-unoptimized-images-with-fiddler

-= PREFERENCES =-
1. You can change the color of the "bricks" by setting the preference "fiddler.ui.Colors.ImageBloat" to the .NET or HTML color string; the default is "#FF4500"
2. You can control whether the "brick" image shows the bloat information text by setting "addons.ImageBloat.EmbedAsText"; the default is "true"
3. You can control whether Fiddler stores a copy of the original response image by setting "addons.ImageBloat.KeepOriginalResponse"; the default is "true"

For instance, if you'd like to use a different fill color, use QuickExec to type

	prefs set fiddler.ui.Colors.ImageBloat #FF4500

...where the color is a hex value or color name.       