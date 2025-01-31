Haven Resource 1 src �  Climb.java /* Preprocessed source code */
package haven.res.lib.climb;

import haven.*;
import haven.render.*;
import java.util.*;
import haven.Skeleton.*;

public class Climb extends Sprite implements Gob.SetupMod, Sprite.CDel {
    public final Composited comp;
    public final Composited.Poses op;
    public Composited.Poses mp;
    public boolean del = false;
    public Location loc = null;

    public Climb(Owner owner, Resource res) {
	super(owner, res);
	try {
	    comp = ((Gob)owner).getattr(Composite.class).comp;
	    op = comp.poses;
	} catch(NullPointerException e) {
	    throw(new Loading("Applying climbing effect to non-complete gob", e));
	}
    }

    public Pipe.Op placestate() {
	return(loc);
    }

    public boolean tick(double dt) {
	if(del)
	    return(true);
	return(false);
    }

    public void delete() {
	if(comp.poses == mp)
	    op.set(Composite.ipollen);
	del = true;
    }
}

src �  UnOffset.java /* Preprocessed source code */
package haven.res.lib.climb;

import haven.*;
import haven.render.*;
import java.util.*;
import haven.Skeleton.*;

public class UnOffset extends TrackMod {
    public final float[] ft;
    public final float[][] toff;
    public Location off = new Location(Matrix4f.identity());
    public float tmod = 1.0f;

    private UnOffset(ModOwner owner, Skeleton skel, Track[] tracks, FxTrack[] fx, float[] ft, float[][] toff, float len, WrapMode mode) {
	skel.super(owner, tracks, fx, len, mode);
	this.ft = ft;
	this.toff = toff;
	aupdate(0.0f);
    }

    public void aupdate(float time) {
	super.aupdate(time);
	if(ft == null)
	    return;
	Coord3f trans;
	if(ft.length == 1) {
	    trans = new Coord3f(toff[0][0], toff[0][1], toff[0][2]);
	} else {
	    float[] cf, nf;
	    float ct, nt;
	    int l = 0, r = ft.length;
	    while(true) {
		/* c should never be able to be >= frames.length */
		int c = l + ((r - l) >> 1);
		ct = ft[c];
		nt = (c < ft.length - 1)?(ft[c + 1]):len;
		if(ct > time) {
		    r = c;
		} else if(nt < time) {
		    l = c + 1;
		} else {
		    cf = toff[c];
		    nf = toff[(c + 1) % toff.length];
		    break;
		}
	    }
	    float d;
	    if(nt == ct)
		d = 0;
	    else
		d = (time - ct) / (nt - ct);
	    trans = new Coord3f(cf[0] + ((nf[0] - cf[0]) * d),
				cf[1] + ((nf[1] - cf[1]) * d),
				cf[2] + ((nf[2] - cf[2]) * d));
	}
	off = Location.xlate(trans);
    }

    /* XXX: It should be possible to subclass UnOffset */
    public boolean tick(float dt) {
	float tmod = this.tmod;
	if(tmod < 0)
	    tmod = 0;
	return(super.tick(dt * tmod));
    }

    public static UnOffset forres(ModOwner owner, Skeleton skel, Skeleton.ResPose pose, WrapMode mode) {
	if(mode == null)
	    mode = pose.defmode;
	Track[] tracks = new Track[pose.tracks.length];
	int tn = 0;
	List<Track> roots = new ArrayList<Track>(pose.tracks.length);
	for(int i = 0; i < tracks.length; i++) {
	    Track t = pose.tracks[i];
	    Bone b = skel.bones.get(t.bone);
	    if(b.parent == null)
		roots.add(t);
	    else
		tracks[tn++] = pose.tracks[i];
	}

	float[] ft = new float[roots.get(0).frames.length];
	for(int i = 0; i < roots.get(0).frames.length; i++)
	    ft[i] = roots.get(0).frames[i].time;
	float[][] toff = new float[ft.length][3];
	for(Track t : roots) {
	    if(t.frames.length != ft.length)
		throw(new RuntimeException("Deviant root track; has " + t.frames.length + " frames, not " + ft.length));
	    for(int i = 0; i < ft.length; i++) {
		Track.Frame f = t.frames[i];
		if(f.time != ft[i])
		    throw(new RuntimeException("Deviant root track; has frame " + i + " at " + f.time + " s, not " + ft[i] + " s"));
		toff[i][0] += f.trans[0];
		toff[i][1] += f.trans[1];
		toff[i][2] += f.trans[2];
	    }
	}
	float ninv = 1.0f / roots.size();
	for(int i = 0; i < ft.length; i++) {
	    toff[i][0] *= ninv;
	    toff[i][1] *= ninv;
	    toff[i][2] *= ninv;
	}
	for(Track t : roots) {
	    Track.Frame[] nf = new Track.Frame[ft.length];
	    for(int i = 0; i < ft.length; i++) {
		float[] trans = new float[3];
		for(int o = 0; o < 3; o++)
		    trans[o] = t.frames[i].trans[o] - toff[i][o];
		nf[i] = new Track.Frame(ft[i], trans, t.frames[i].rot);
	    }
	    tracks[tn++] = new Track(t.bone, nf);
	}

	Track[] remap = new Track[skel.blist.length];
	for(Track t : tracks)
	    remap[skel.bones.get(t.bone).idx] = t;
	UnOffset ret = new UnOffset(owner, skel, remap, pose.effects, ft, toff, pose.len, mode);
	return(ret);
    }
}
code �  haven.res.lib.climb.Climb ����   4 [
  7	  8	  9 : ;
  <	  =	  =	 > ?	  @ A B C
  D	  E>L��
  F G H I K comp Lhaven/Composited; op M Poses InnerClasses Lhaven/Composited$Poses; mp del Z loc Lhaven/render/Location; <init> N Owner '(Lhaven/Sprite$Owner;Lhaven/Resource;)V Code LineNumberTable StackMapTable G N O A 
placestate Q Op ()Lhaven/render/Pipe$Op; tick (D)Z delete ()V 
SourceFile 
Climb.java " %     ! 	haven/Gob haven/Composite R S   T U    java/lang/NullPointerException haven/Loading ,Applying climbing effect to non-complete gob " V   W X haven/res/lib/climb/Climb haven/Sprite haven/Gob$SetupMod SetupMod haven/Sprite$CDel CDel haven/Composited$Poses haven/Sprite$Owner haven/Resource Y haven/render/Pipe$Op getattr "(Ljava/lang/Class;)Lhaven/GAttrib; haven/Composited poses *(Ljava/lang/String;Ljava/lang/Throwable;)V set (F)V haven/render/Pipe climb.cjava !                              !     " %  &   �     >*+,� *� *� *+� � � � � **� � 	� 
� N� Y-� ��   . 1   (    � 1  ) * +  , '   & 	          #  .  1  2  =   - 0  &        *� �    '         1 2  &   4     *� � ��    (    	 '          	    3 4  &   J     *� � 	*� � *� 
� *� �    (     '       $  %  &  '  5    Z    *   >   #  $	 . P /	   J	   L	code 3  haven.res.lib.climb.UnOffset ����   4 �
 i j
 = k l
 m n
  o	 9 p	 9 q	 9 r	 9 s
 9 t
 = t u
  v	 9 w
  x
 = y	 Y z	 Y { } ~
  	 | �	  � � � �	  � � � � �	  �	 3 � A � � � � � � � �
 $ � �
 $ �
 $ � �
 $ �
 # � � �
 $ � � �	 3 � � � �	 3 �
 3 �
  �	 | �	  � �	 Y �	 Y w
 9 � � ft [F toff [[F off Lhaven/render/Location; tmod F <init> � ModOwner InnerClasses Track � FxTrack r(Lhaven/Skeleton$ModOwner;Lhaven/Skeleton;[Lhaven/Skeleton$Track;[Lhaven/Skeleton$FxTrack;[F[[FFLhaven/WrapMode;)V Code LineNumberTable aupdate (F)V StackMapTable � ? u tick (F)Z forres � ResPose q(Lhaven/Skeleton$ModOwner;Lhaven/Skeleton;Lhaven/Skeleton$ResPose;Lhaven/WrapMode;)Lhaven/res/lib/climb/UnOffset; � � � � � � } � � � � 
SourceFile UnOffset.java � � � F � haven/render/Location � � � F � B C D E > ? @ A P Q haven/Coord3f F � � E � � V W � � � � � haven/Skeleton$Track java/util/ArrayList F � � � � � � � � haven/Skeleton$Bone Bone � � � � � � � � � � E � � � � � � � java/lang/RuntimeException java/lang/StringBuilder F � Deviant root track; has  � � � �  frames, not  � � F � Deviant root track; has frame   at  � �  s, not   s � ? � � haven/Skeleton$Track$Frame Frame � ? F � F � � � � � haven/res/lib/climb/UnOffset � � F M haven/Skeleton$TrackMod TrackMod haven/Skeleton$ModOwner haven/Skeleton$FxTrack haven/Skeleton$ResPose haven/Skeleton haven/WrapMode [Lhaven/Skeleton$Track; java/util/List java/util/Iterator [Lhaven/Skeleton$Track$Frame; java/lang/Object getClass ()Ljava/lang/Class; m(Lhaven/Skeleton;Lhaven/Skeleton$ModOwner;[Lhaven/Skeleton$Track;[Lhaven/Skeleton$FxTrack;FLhaven/WrapMode;)V haven/Matrix4f identity ()Lhaven/Matrix4f; (Lhaven/Matrix4f;)V (FFF)V len xlate ((Lhaven/Coord3f;)Lhaven/render/Location; defmode Lhaven/WrapMode; tracks (I)V bones Ljava/util/Map; bone Ljava/lang/String; java/util/Map get &(Ljava/lang/Object;)Ljava/lang/Object; parent Lhaven/Skeleton$Bone; add (Ljava/lang/Object;)Z (I)Ljava/lang/Object; frames time iterator ()Ljava/util/Iterator; hasNext ()Z next ()Ljava/lang/Object; ()V append -(Ljava/lang/String;)Ljava/lang/StringBuilder; (I)Ljava/lang/StringBuilder; toString ()Ljava/lang/String; (Ljava/lang/String;)V (F)Ljava/lang/StringBuilder; trans size ()I rot (F[F[F)V 2(Ljava/lang/String;[Lhaven/Skeleton$Track$Frame;)V blist [Lhaven/Skeleton$Bone; idx I effects [Lhaven/Skeleton$FxTrack; climb.cjava ! 9 =     > ?    @ A    B C    D E     F M  N   g  	   7*,Y� W+-� *� Y� � � *� *� *� 	*� 
�    O       1  -   . % 2 + 3 1 4 6 5  P Q  N  �  
  *#� *� � �*� �� &� Y*� 	20*� 	20*� 	20� M� �6*� �6dz`6	*� 	08	*� �d� *� 	`0� *� 8#�� 
	6� /#�� 	`6� *� 		2N*� 		`*� 	�p2:� ����� 	8	� #ffn8	� Y-00-0f	jb-00-0f	jb-00-0f	jb� M*,� � �    R   k +� 	 	 S       � , 
 S      C�  
 S     � �  	 S  T T  � � 4  S U   O   ^    8  9  :  <  = 9 A C D O E X F v G } H � I � J � L � M � N � P � R � S � U � V Z
 [  V W  N   E     *� E$�� E*#$j� �    R    �  O       _  `  a  b 	 X [  N  � 
   �-� ,� N,� �� :6� Y,� �� :6�� I,� 2:+� � �  � :		� � �  W� �,� 2S�����  � � ��:6�  � � �� "�  � � 2� Q������ :�   :		� ! � �	� " � :

� ��� .� #Y� $Y� %&� '
� �� ()� '�� (� *� +�6�� �
� 2:� 0�� >� #Y� $Y� %,� '� (-� '� � ./� '0� .0� '� *� +�2\0� 10bQ2\0� 10bQ2\0� 10bQ���o��� 2 �n8	6

�� -
2\0	jQ
2\0	jQ
2\0	jQ�
����   :

� ! � �
� " � :�� 3:6�� W�:6� %� 2� 1020fQ����� 3Y0� 2� 4� 5S������ Y� � 6S��m+� 7�� :
:�66� )2:
+� � �  � � 8S���ֻ 9Y*+
,� :,� ;-� <:�    R   � 	�   \ ] ^ _ ` a  � 8 b c� � �  T� 2�   d� L b� � Z e� 8� � � 1�  d�   b f�  T� '� #� �   \ ] ^ _ ` a T  ` `  � , O   � 4   f  g 	 h  i  j $ k / l 8 m K n S o ` q o k u t � u � v � u � w � x � y � z {) |3 }A ~| � �� �� {� �� �� �� �� �� �� �� � �  �+ �0 �9 �U �[ �y � �� �� �� �� �� �� �� �  g    � I   :  G | H	  | J 	 K | L 	 Y | Z 	  | � 	 3  � 	 = | � codeentry     