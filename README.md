# MaskedTextField

A subclass of UITextField which automatically places auxiliary characters during the editing.

.text property contains only significant characters – i. e. the characters entered by the user.
For instance, when the template is "+_ ___ ___-__-__" and the user entered a phone number +7 900 816-04-28, .text property contains the value "79008160428". Spaces, dashes and plus sign are not visible outside.

You can use it everywhere you use UITextField.
