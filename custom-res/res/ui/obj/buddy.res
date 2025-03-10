Haven Resource 1 src �  Info.java /* Preprocessed source code */
package haven.res.ui.obj.buddy;

import haven.*;
import haven.render.*;
import java.util.*;
import java.awt.Color;

public class Info extends GAttrib implements RenderTree.Node, PView.Render2D {
    public final List<InfoPart> parts = new ArrayList<>();
    private Tex rend = null;
    private boolean dirty;
    private double seen = 0;
    private boolean auto;

    public Info(Gob gob) {
	super(gob);
    }

    public void draw(GOut g, Pipe state) {
	Coord sc = Homo3D.obj2view(new Coord3f(0, 0, 15), state, Area.sized(g.sz())).round2();
	if(dirty) {
	    RenderContext ctx = state.get(RenderContext.slot);
	    CompImage cmp = new CompImage();
	    dirty = false;
	    auto = false;
	    for(InfoPart part : parts) {
		try {
		    part.draw(cmp, ctx);
		    auto |= part.auto();
		} catch(Loading l) {
		    dirty = true;
		}
	    }
	    rend = cmp.sz.equals(Coord.z) ? null : new TexI(cmp.compose());
	}
	if((rend != null) && sc.isect(Coord.z, g.sz())) {
	    double now = Utils.rtime();
	    if(seen == 0)
		seen = now;
	    double tm = now - seen;
	    Color show = null;
	    if(false) {
		/* XXX: QQ, RIP in peace until constant
		 * mouse-over checks can be had. */
		if(auto && (tm < 7.5)) {
		    show = Utils.clipcol(255, 255, 255, (int)(255 - ((255 * tm) / 7.5)));
		}
	    } else {
		show = Color.WHITE;
	    }
	    if(show != null) {
		g.chcolor(show);
		g.aimage(rend, sc, 0.5, 1.0);
		g.chcolor();
	    }
	} else {
	    seen = 0;
	}
    }

    public void dirty() {
	if(rend != null)
	    rend.dispose();
	rend = null;
	dirty = true;
    }

    public static Info add(Gob gob, InfoPart part) {
	Info info = gob.getattr(Info.class);
	if(info == null)
	    gob.setattr(info = new Info(gob));
	info.parts.add(part);
	Collections.sort(info.parts, Comparator.comparing(InfoPart::order));
	info.dirty();
	return(info);
    }

    public void remove(InfoPart part) {
	parts.remove(part);
	dirty();
    }
}

src o  InfoPart.java /* Preprocessed source code */
package haven.res.ui.obj.buddy;

import haven.*;
import haven.render.*;
import java.util.*;
import java.awt.Color;

public interface InfoPart {
    public void draw(CompImage cmp, RenderContext ctx);
    public default int order() {return(0);}
    public default boolean auto() {return(false);}
}

/* >objdelta: Buddy */
src �  Buddy.java /* Preprocessed source code */
package haven.res.ui.obj.buddy;

import haven.*;
import haven.render.*;
import java.util.*;
import java.awt.Color;

public class Buddy extends GAttrib implements InfoPart {
    public final int id;
    public final Info info;
    private int bseq = -1;
    private BuddyWnd bw = null;
    private BuddyWnd.Buddy b = null;
    private int rgrp;
    private String rnm;

    public Buddy(Gob gob, int id) {
	super(gob);
	this.id = id;
	info = Info.add(gob, this);
    }

    public static void parse(Gob gob, Message dat) {
	int fl = dat.uint8();
	if((fl & 1) != 0)
	    gob.setattr(new Buddy(gob, dat.int32()));
	else
	    gob.delattr(Buddy.class);
    }

    public void dispose() {
	super.dispose();
	info.remove(this);
    }

    public BuddyWnd.Buddy buddy() {
	return(b);
    }

    public void draw(CompImage cmp, RenderContext ctx) {
	BuddyWnd.Buddy b = null;
	if(bw == null) {
	    if(ctx instanceof PView.WidgetContext) {
		GameUI gui = ((PView.WidgetContext)ctx).widget().getparent(GameUI.class);
		if(gui != null) {
		    if(gui.buddies == null)
			throw(new Loading());
		    bw = gui.buddies;
		}
	    }
	}
	if(bw != null)
	    b = bw.find(id);
	if(b != null) {
	    Color col = BuddyWnd.gc[rgrp = b.group];
	    cmp.add(Utils.outline2(Text.std.render(rnm = b.name, col).img, Utils.contrast(col)), Coord.z);
	}
	this.b = b;
    }

    public void ctick(double dt) {
	super.ctick(dt);
	if((bw != null) && (bw.serial != bseq)) {
	    bseq = bw.serial;
	    if((bw.find(id) != b) || (rnm != b.name) || (rgrp != b.group))
		info.dirty();
	}
    }

    public boolean auto() {return(true);}
    public int order() {return(-10);}
}
code �  haven.res.ui.obj.buddy.Info ����   4 �
 5 [ \
  ]	 + ^	 + _	 + ` aAp  
  b
 c d
 e f
 g h
  i	 + j	  k l m n o
  ]	 + p q r s t s u v  w  x y	  z	 { |
 { } ~
  
  �
 { �
 � �	 � �
 c �?�      
 c �
 c � � � �
 � �
 + [
 � � q �   � � �
 � �
 + � q � � � � parts Ljava/util/List; 	Signature 3Ljava/util/List<Lhaven/res/ui/obj/buddy/InfoPart;>; rend Lhaven/Tex; dirty Z seen D auto <init> (Lhaven/Gob;)V Code LineNumberTable draw "(Lhaven/GOut;Lhaven/render/Pipe;)V StackMapTable � � � � n o � v y � ()V add K(Lhaven/Gob;Lhaven/res/ui/obj/buddy/InfoPart;)Lhaven/res/ui/obj/buddy/Info; remove $(Lhaven/res/ui/obj/buddy/InfoPart;)V 
SourceFile 	Info.java C D java/util/ArrayList C T 8 9 < = @ A haven/Coord3f C � � � � � � � � � � � � > ? � � � � � haven/RenderContext haven/CompImage B ? � � � � � � � � haven/res/ui/obj/buddy/InfoPart G � B � haven/Loading � � � � � � � 
haven/TexI � � C � � � � � � � � � � � � � � T � � T haven/res/ui/obj/buddy/Info � � � � � U � BootstrapMethods � �	 � � � � � � � � � � > T W � haven/GAttrib � haven/render/RenderTree$Node Node InnerClasses � haven/PView$Render2D Render2D 
haven/GOut haven/render/Pipe haven/Coord java/util/Iterator 	haven/Tex (FFF)V sz ()Lhaven/Coord; 
haven/Area sized (Lhaven/Coord;)Lhaven/Area; haven/render/Homo3D obj2view ?(Lhaven/Coord3f;Lhaven/render/Pipe;Lhaven/Area;)Lhaven/Coord3f; round2 slot � Slot Lhaven/render/State$Slot; get /(Lhaven/render/State$Slot;)Lhaven/render/State; java/util/List iterator ()Ljava/util/Iterator; hasNext ()Z next ()Ljava/lang/Object; )(Lhaven/CompImage;Lhaven/RenderContext;)V Lhaven/Coord; z equals (Ljava/lang/Object;)Z compose  ()Ljava/awt/image/BufferedImage; !(Ljava/awt/image/BufferedImage;)V isect (Lhaven/Coord;Lhaven/Coord;)Z haven/Utils rtime ()D java/awt/Color WHITE Ljava/awt/Color; chcolor (Ljava/awt/Color;)V aimage (Lhaven/Tex;Lhaven/Coord;DD)V dispose 	haven/Gob getattr "(Ljava/lang/Class;)Lhaven/GAttrib; setattr (Lhaven/GAttrib;)V
 � � &(Ljava/lang/Object;)Ljava/lang/Object;  � 6(Lhaven/res/ui/obj/buddy/InfoPart;)Ljava/lang/Integer; apply ()Ljava/util/function/Function; java/util/Comparator 	comparing 5(Ljava/util/function/Function;)Ljava/util/Comparator; java/util/Collections sort )(Ljava/util/List;Ljava/util/Comparator;)V haven/render/RenderTree haven/PView � haven/render/State$Slot � � � � � haven/render/State "java/lang/invoke/LambdaMetafactory metafactory � Lookup �(Ljava/lang/invoke/MethodHandles$Lookup;Ljava/lang/String;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodType;Ljava/lang/invoke/MethodHandle;Ljava/lang/invoke/MethodType;)Ljava/lang/invoke/CallSite; order ()I � %java/lang/invoke/MethodHandles$Lookup java/lang/invoke/MethodHandles buddy.cjava ! + 5  6 7   8 9  :    ;  < =    > ?    @ A    B ?     C D  E   C     *+� *� Y� � *� *� �    F         	  
      G H  E    	  � Y� 	,+� 
� � � N*� � �,� �  � :� Y� :*� *� *� �  :�  � 7�  � :�  *Y� �  �� � 
:*� ���*� � � � � � Y�  � !� *� � U-� +� 
� "� G� #9*� �� 	*� *� g9:� $:� +� %+*� - &� (+� )� *� �  c ~ �   I   u � M  J K L M N O P  � 3  J K L M N O P Q  R� � R J�   J K L M N O  J S� � (� , F   r       !  /  8  =  B  c  n  ~   �  �  � ! � " � $ � % � & � ' � ( � ) � 1 � 3 � 4 � 5 � 6 8 9 ;  > T  E   L     *� � *� � * *� *� �    I     F       >  ?  @  A  B 	 U V  E   z     <*+� ,� +M,� *� +Y*� -YM� .,� +� / W,� � 0  � 1� 2,� 3,�    I    �  J F       E 
 F  G  H ' I 6 J : K  W X  E   0     *� +� 4 W*� 3�    F       O  P  Q  �     �  � � � Y    � �   "  6 � �	 7 � �	 � � � 	 � � � code e  haven.res.ui.obj.buddy.InfoPart ����   4    draw )(Lhaven/CompImage;Lhaven/RenderContext;)V order ()I Code LineNumberTable auto ()Z 
SourceFile InfoPart.java haven/res/ui/obj/buddy/InfoPart java/lang/Object buddy.cjava                        �           V  	 
          �           W      code �  haven.res.ui.obj.buddy.Buddy ����   4 �
 ' O	 	 P	 	 Q	 	 R	 	 S
 T U	 	 V
 W X Y
 W Z
 	 [
 \ ]
 \ ^
 ' _
 T ` b
  d e
 a f	  g h
  i
 j k	 j l	 1 m	 	 n	 o p	 1 q	 	 r
 s t	 u v
 w x
 w y	 z {
 | }
 ' ~	 j 
 T � � � id I info Lhaven/res/ui/obj/buddy/Info; bseq bw Lhaven/BuddyWnd; b � Buddy InnerClasses Lhaven/BuddyWnd$Buddy; rgrp rnm Ljava/lang/String; <init> (Lhaven/Gob;I)V Code LineNumberTable parse (Lhaven/Gob;Lhaven/Message;)V StackMapTable dispose ()V buddy ()Lhaven/BuddyWnd$Buddy; draw )(Lhaven/CompImage;Lhaven/RenderContext;)V � e ctick (D)V auto ()Z order ()I 
SourceFile 
Buddy.java 8 � - * . / 0 4 ) * � � � + , � � L haven/res/ui/obj/buddy/Buddy � L 8 9 � � � � � ? @ � � � haven/PView$WidgetContext WidgetContext � � haven/GameUI � � � / haven/Loading 8 @ � � � � � � * 5 * � � � � 7 6 7 � � � � � � � � � � � � � � � � � G H � * � @ haven/GAttrib haven/res/ui/obj/buddy/InfoPart haven/BuddyWnd$Buddy (Lhaven/Gob;)V haven/res/ui/obj/buddy/Info add K(Lhaven/Gob;Lhaven/res/ui/obj/buddy/InfoPart;)Lhaven/res/ui/obj/buddy/Info; haven/Message uint8 int32 	haven/Gob setattr (Lhaven/GAttrib;)V delattr (Ljava/lang/Class;)V remove $(Lhaven/res/ui/obj/buddy/InfoPart;)V haven/PView widget ()Lhaven/PView; 	getparent !(Ljava/lang/Class;)Lhaven/Widget; buddies haven/BuddyWnd find (I)Lhaven/BuddyWnd$Buddy; gc [Ljava/awt/Color; group 
haven/Text std Foundry Lhaven/Text$Foundry; name haven/Text$Foundry render Line 5(Ljava/lang/String;Ljava/awt/Color;)Lhaven/Text$Line; haven/Text$Line img Ljava/awt/image/BufferedImage; haven/Utils contrast "(Ljava/awt/Color;)Ljava/awt/Color; outline2 N(Ljava/awt/image/BufferedImage;Ljava/awt/Color;)Ljava/awt/image/BufferedImage; haven/Coord z Lhaven/Coord; haven/CompImage >(Ljava/awt/image/BufferedImage;Lhaven/Coord;)Lhaven/CompImage; serial dirty buddy.cjava ! 	 '  (   ) *    + ,    - *    . /    0 4    5 *    6 7     8 9  :   S     #*+� *� *� *� *� *+*� � �    ;       e  ^ 
 _  `  f  g " h 	 < =  :   Z     %+� =~� *� 	Y*+� 
� � � 	*	� �    >    �  ;       k  l  m  o $ p  ? @  :   -     *� *� *� �    ;       s  t  u  A B  :        *� �    ;       x  C D  :   �     �N*� � 9,� � 2,� � � � :� � � � Y� �*� � *� � *� *� � N-� 6� *-� Z� 2:+� *-� Z� � � �  � !� "� #W*-� �    >    � 6 E F� 6 ;   >    |  } 	 ~   ! � & � . � 6 � ? � F � R � V � e � � � � �  G H  :   �     [*'� $*� � Q*� � %*� � C**� � %� *� *� � *� � *� *� � � *� *� � � 
*� � &�    >    � S ;       �  �  � % � S � Z �  I J  :        �    ;       �  K L  :        ��    ;       �  M    � 3   "  1 j 2   a c 	 s o � 	 u o � 	codeentry )   objdelta haven.res.ui.obj.buddy.Buddy   