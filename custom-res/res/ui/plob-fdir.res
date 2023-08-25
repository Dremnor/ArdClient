Haven Resource 1 src �  Fixedplob.java /* Preprocessed source code */
import haven.*;
import haven.MapView.Plob;
import static haven.MCache.tilesz;

/* >spr: Fixedplob */
public class Fixedplob extends Sprite implements MapView.PlobAdjust {
    public final double a;

    public Fixedplob(Owner owner, Resource res, Message sdt) {
	super(owner, res);
	this.a = Math.PI * 2 * (sdt.uint8() / 180.0);
	if(owner instanceof Plob) {
	    ((Plob)owner).adjust = this;
	}
    }

    public void adjust(Plob plob, Coord pc, Coord2d mc, int modflags) {
	Coord2d nc;
	if((modflags & UI.MOD_SHIFT) == 0)
	    nc = mc.floor(tilesz).mul(tilesz).add(tilesz.div(2));
	else
	    nc = mc;
	plob.move(nc, a);
    }

    public boolean rotate(Plob plob, int amount, int modflags) {
	return(false);
    }
}
code G  Fixedplob ����   4 ^
  - .@!�TD-
 / 0@f�     	  1 3	 	 4	 5 6	 7 8
 9 :
 ; <@       
 9 =
 9 >
 	 ? @ A B a D <init> D Owner InnerClasses 6(Lhaven/Sprite$Owner;Lhaven/Resource;Lhaven/Message;)V Code LineNumberTable StackMapTable @ D E F adjust Plob 4(Lhaven/MapView$Plob;Lhaven/Coord;Lhaven/Coord2d;I)V G rotate (Lhaven/MapView$Plob;II)Z 
SourceFile Fixedplob.java  H java/lang/Math F I J   K haven/MapView$Plob % L M N O P Q R G S T U V W X Y Z W [ \ 	Fixedplob haven/Sprite haven/MapView$PlobAdjust 
PlobAdjust haven/Sprite$Owner haven/Resource haven/Message haven/Coord2d '(Lhaven/Sprite$Owner;Lhaven/Resource;)V uint8 ()I haven/MapView Lhaven/MapView$PlobAdjust; haven/UI 	MOD_SHIFT I haven/MCache tilesz Lhaven/Coord2d; floor (Lhaven/Coord2d;)Lhaven/Coord; haven/Coord mul  (Lhaven/Coord2d;)Lhaven/Coord2d; div (D)Lhaven/Coord2d; add move (Lhaven/Coord2d;D)V plob-fdir.cjava !                   j     '*+,� * -� � ok� +� 	� +� 	*� 
�         � &  ! " # $          
       &   % '     l     5� ~� !-� � � � �  � � :� -:+*� � �        	 '�  (         	  '  *  4   ) *          �             +    ]        	 	 2 &   2 C	codeentry    spr Fixedplob   