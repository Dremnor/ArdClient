Haven Resource 1 src �  Dirplob.java /* Preprocessed source code */
import haven.*;
import haven.MapView.Plob;

/* >spr: Dirplob */
public class Dirplob extends Sprite implements MapView.PlobAdjust {
    public final Coord2d sc;
    public final int dirs;

    public Dirplob(Owner owner, Resource res, Message sdt) {
	super(owner, res);
	sc = new Coord(sdt.int32(), sdt.int32()).mul(OCache.posres);
	dirs = sdt.uint8();
	if(owner instanceof Plob) {
	    Plob po = (Plob)owner;
	    po.adjust = this;
	    po.move(sc);
	}
    }

    public void adjust(Plob plob, Coord pc, Coord2d mc, int modflags) {
	double cl = Double.NaN, md = Double.POSITIVE_INFINITY;
	double mdir = sc.angle(mc);
	for(int dir = 0; dir < 4; dir++) {
	    if((dirs & (1 << dir)) == 0)
		continue;
	    double ca = (dir - 1) * Math.PI / 2;
	    double cd = Math.abs(Utils.cangle(mdir - ca));
	    if(Double.isNaN(cl) || cd < md) {
		cl = ca;
		md = cd;
	    }
	}
	plob.move(cl);
    }

    public boolean rotate(Plob plob, int amount, int modflags) {
	return(false);
    }
}
code <  Dirplob ����   4 p
  9 :
 ; <
  =	 > ?
  @	  A
 ; B	  C E	 
 F
 
 G H�      �      
 I J K@	!�TD-@       
 L M
  N
  O
 
 P Q R S sc Lhaven/Coord2d; dirs I <init> U Owner InnerClasses 6(Lhaven/Sprite$Owner;Lhaven/Resource;Lhaven/Message;)V Code LineNumberTable StackMapTable Q U V W adjust Plob 4(Lhaven/MapView$Plob;Lhaven/Coord;Lhaven/Coord2d;I)V E : X rotate (Lhaven/MapView$Plob;II)Z 
SourceFile Dirplob.java # Y haven/Coord W Z [ # \ ] ^   _ `    a [ ! " b haven/MapView$Plob / c d e java/lang/Double X f g java/lang/Math h i j k j l m d n Dirplob haven/Sprite haven/MapView$PlobAdjust 
PlobAdjust haven/Sprite$Owner haven/Resource haven/Message haven/Coord2d '(Lhaven/Sprite$Owner;Lhaven/Resource;)V int32 ()I (II)V haven/OCache posres mul  (Lhaven/Coord2d;)Lhaven/Coord2d; uint8 haven/MapView Lhaven/MapView$PlobAdjust; move (Lhaven/Coord2d;)V angle (Lhaven/Coord2d;)D haven/Utils cangle (D)D abs isNaN (D)Z (D)V plob-dir.cjava !             ! "     # '  (   �     D*+,� *� Y-� -� � � � � *-� � 	+� 
� +� 
:*� *� � �    *    � C  + , - .   )   "    
     '  .  4  :  C   / 1  (   �     m 9 9*� -� 9	6� L*� 	x~� � 7d� k o9	g� � 9� � �� 99����+� �    *   & �  	 + 2 3 4  � +� �  )   6     
      )  ,  ;  H  X  \  `  f ! l "  5 6  (        �    )       %  7    o &     $  %	 
 D 0   D T	codeentry    spr Dirplob   