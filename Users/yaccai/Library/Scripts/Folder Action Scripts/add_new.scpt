FasdUAS 1.101.10   ��   ��    k             l      ��  ��   ��
add - new item alert

This Folder Action handler is triggered whenever items are added to the attached folder.
The script will display an alert containing the number of items added and offering the user
the option to reveal the added items in Finder.

Copyright � 2002�2007 Apple Inc.

You may incorporate this Apple sample code into your program(s) without
restriction.  This Apple sample code has been provided "AS IS" and the
responsibility for its operation is yours.  You are not permitted to
redistribute this Apple sample code as "Apple sample code" after having
made changes.  If you're going to redistribute the code, we require
that you make it clear that the code was descended from Apple sample
code, but that you've made changes.
     � 	 	� 
 a d d   -   n e w   i t e m   a l e r t 
 
 T h i s   F o l d e r   A c t i o n   h a n d l e r   i s   t r i g g e r e d   w h e n e v e r   i t e m s   a r e   a d d e d   t o   t h e   a t t a c h e d   f o l d e r . 
 T h e   s c r i p t   w i l l   d i s p l a y   a n   a l e r t   c o n t a i n i n g   t h e   n u m b e r   o f   i t e m s   a d d e d   a n d   o f f e r i n g   t h e   u s e r 
 t h e   o p t i o n   t o   r e v e a l   t h e   a d d e d   i t e m s   i n   F i n d e r . 
 
 C o p y r i g h t   �   2 0 0 2  2 0 0 7   A p p l e   I n c . 
 
 Y o u   m a y   i n c o r p o r a t e   t h i s   A p p l e   s a m p l e   c o d e   i n t o   y o u r   p r o g r a m ( s )   w i t h o u t 
 r e s t r i c t i o n .     T h i s   A p p l e   s a m p l e   c o d e   h a s   b e e n   p r o v i d e d   " A S   I S "   a n d   t h e 
 r e s p o n s i b i l i t y   f o r   i t s   o p e r a t i o n   i s   y o u r s .     Y o u   a r e   n o t   p e r m i t t e d   t o 
 r e d i s t r i b u t e   t h i s   A p p l e   s a m p l e   c o d e   a s   " A p p l e   s a m p l e   c o d e "   a f t e r   h a v i n g 
 m a d e   c h a n g e s .     I f   y o u ' r e   g o i n g   t o   r e d i s t r i b u t e   t h e   c o d e ,   w e   r e q u i r e 
 t h a t   y o u   m a k e   i t   c l e a r   t h a t   t h e   c o d e   w a s   d e s c e n d e d   f r o m   A p p l e   s a m p l e 
 c o d e ,   b u t   t h a t   y o u ' v e   m a d e   c h a n g e s . 
   
  
 l     ��������  ��  ��        l      ��  ��    Q K
??? -->  /Library/Scripts/Folder Action Scripts/add - new item alert.scpt
     �   � 
O�e9N�   - - >     / L i b r a r y / S c r i p t s / F o l d e r   A c t i o n   S c r i p t s / a d d   -   n e w   i t e m   a l e r t . s c p t 
      l     ��������  ��  ��        i         I     ��  
�� .facofgetnull���     alis  o      ���� 0 this_folder    �� ��
�� 
flst  o      ���� 0 added_items  ��    Q     c  ��  O    Z    X    Y ��   k    T      ! " ! r     # $ # n     % & % 1    ��
�� 
pnam & o    ���� 
0 anitem   $ o      ���� 0 f   "  ' ( ' r    " ) * ) b      + , + m     - - � . . 6 M a c : U s e r s : y a c c a i : D o w n l o a d s : , o    ���� 0 f   * o      ���� 0 src   (  / 0 / r   # , 1 2 1 c   # * 3 4 3 b   # ( 5 6 5 b   # & 7 8 7 m   # $ 9 9 � : :  e c h o   " 8 o   $ %���� 0 f   6 m   & ' ; ; � < < P " |   s e d   ' s / ^ [ 0 - 9 a - z ] \ { 4 0 , 5 0 \ } . t o r r e n t $ / / ' 4 m   ( )��
�� 
TEXT 2 o      ���� 0 cmd   0  = > = l  - -�� ? @��   ? 0 *set res to (do shell script cmd) as string    @ � A A T s e t   r e s   t o   ( d o   s h e l l   s c r i p t   c m d )   a s   s t r i n g >  B�� B Z   - T C D���� C =  - 4 E F E l  - 2 G���� G I  - 2�� H��
�� .sysoexecTEXT���     TEXT H o   - .���� 0 cmd  ��  ��  ��   F m   2 3 I I � J J   D k   7 P K K  L M L I  7 @�� N��
�� .sysoexecTEXT���     TEXT N b   7 < O P O m   7 8 Q Q � R R & o p e n   - g a   T h u n d e r       P l  8 ; S���� S n   8 ; T U T 1   9 ;��
�� 
psxp U o   8 9���� 0 src  ��  ��  ��   M  V W V I  A F�� X��
�� .sysodelanull��� ��� nmbr X m   A B���� ��   W  Y�� Y I  G P�� Z [
�� .coremovenull���     obj  Z o   G H���� 0 src   [ �� \��
�� 
insh \ l  I L ]���� ] 1   I L��
�� 
trsh��  ��  ��  ��  ��  ��  ��  �� 
0 anitem    o   
 ���� 0 added_items    m     ^ ^�                                                                                  MACS  alis    .  Mac                            BD ����
Finder.app                                                     ����            ����  
 cu             CoreServices  )/:System:Library:CoreServices:Finder.app/    
 F i n d e r . a p p    M a c  &System/Library/CoreServices/Finder.app  / ��    R      ������
�� .ascrerr ****      � ****��  ��  ��     _�� _ l     ��������  ��  ��  ��       �� ` a��   ` ��
�� .facofgetnull���     alis a �� ���� b c��
�� .facofgetnull���     alis�� 0 this_folder  �� ������
�� 
flst�� 0 added_items  ��   b �������������� 0 this_folder  �� 0 added_items  �� 
0 anitem  �� 0 f  �� 0 src  �� 0 cmd   c  ^�������� - 9 ;���� I Q��������������
�� 
kocl
�� 
cobj
�� .corecnte****       ****
�� 
pnam
�� 
TEXT
�� .sysoexecTEXT���     TEXT
�� 
psxp
�� .sysodelanull��� ��� nmbr
�� 
insh
�� 
trsh
�� .coremovenull���     obj ��  ��  �� d \� T Q�[��l kh ��,E�O�%E�O�%�%�&E�O�j 	�  ��,%j 	Okj O��*�,l Y h[OY��UW X  h ascr  ��ޭ