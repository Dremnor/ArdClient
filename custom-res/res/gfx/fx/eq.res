Haven Resource 1 src   Equed.java /* Preprocessed source code */
package haven.res.gfx.fx.eq;

import haven.*;
import haven.render.*;

/*
  >spr: Equed
  >rlink: Equed
*/
public class Equed extends Sprite {
    private final Sprite espr;
    private final RenderTree.Node eqd;
    
    public Equed(Owner owner, Resource res, Sprite espr, Skeleton.BoneOffset bo) {
	super(owner, res);
	this.espr = espr;
	this.eqd = RUtils.StateTickNode.from(this.espr, bo.from(owner.fcontext(EquipTarget.class, false)));
    }

    public static Resource ctxres(Owner owner) {
	Gob gob = owner.context(Gob.class);
	if(gob == null)
	    throw(new RuntimeException("no context resource for owner " + owner));
	Drawable d = gob.getattr(Drawable.class);
	if(d == null)
	    throw(new RuntimeException("no drawable on object " +gob));
	return(d.getres());
    }

    public static Equed mksprite(Owner owner, Resource res, Message sdt) {
	Indir<Resource> eres = owner.context(Resource.Resolver.class).getres(sdt.uint16());
	int fl = sdt.uint8();
	String epn = sdt.string();
	Resource epres = ((fl & 1) == 0) ? (ctxres(owner)) : eres.get();
	Message sub = Message.nil;
	if((fl & 2) != 0)
	    sub = new MessageBuf(sdt.bytes(sdt.uint8()));
	Skeleton.BoneOffset bo = epres.layer(Skeleton.BoneOffset.class, epn);
	if(bo == null)
	    throw(new RuntimeException("No such bone-offset in " + epres.name + ": " + epn));
	return(new Equed(owner, res, Sprite.create(owner, eres.get(), sub), bo));
    }

    public static Equed mkrlink(Owner owner, Resource res, Object... args) {
	String epn = (String)args[0];
	String fl = (String)args[1];
	Resource eres = res.pool.load((String)args[2], (Integer)args[3]).get();
	Resource epres;
	if(fl.indexOf('l') >= 0)
	    epres = eres;
	else if(fl.indexOf("c") >= 0)
	    epres = ctxres(owner);
	else if(fl.indexOf("o") >= 0)
	    epres = res;
	else
	    epres = res;
	Sprite espr;
	if((args.length > 4) && (args[4] instanceof byte[])) {
	    espr = Sprite.create(owner, eres, new MessageBuf((byte[])args[4]));
	} else if((args.length > 4) && (args[4] instanceof Object[])) {
	    RenderTree.Node n = eres.getcode(RenderLink.ArgLink.class, true).create(owner, res, (Object[])args[4]);
	    if(!(n instanceof Sprite))
		throw(new Sprite.ResourceException("Sublink returned non-sprite node " + String.valueOf(n), eres));
	    espr = (Sprite)n;
	} else {
	    espr = Sprite.create(owner, eres, Message.nil);
	}
	Skeleton.BoneOffset bo = epres.layer(Skeleton.BoneOffset.class, epn);
	if(bo == null)
	    throw(new RuntimeException("No such bone-offset in " + epres.name + ": " + epn));
	return(new Equed(owner, res, espr, bo));
    }
    
    public void added(RenderTree.Slot slot) {
	slot.add(eqd);
    }
    
    public boolean tick(double dt) {
	espr.tick(dt);
	return(false);
    }

    public void age() {
	espr.age();
    }
}
code   haven.res.gfx.fx.eq.Equed ����   4 �
 9 i	 ' j k I l
 " m
 n o	 ' p q I r s t
  u v
  w
  x
  y
 
 z {
  | }
  ~ 
 � �  �
 � �
 � �
 ' � � � �	 � � �
 � �
  � �
  � �	  � � �
 9 �
 ' � �	  � �
 , �
 � �
 � �
 * � �
 * � � � � �
  � 6 � � � �
 * �
 : � ` �
 9 �
 9 � espr Lhaven/Sprite; eqd � Node InnerClasses Lhaven/render/RenderTree$Node; <init> � Owner 
BoneOffset P(Lhaven/Sprite$Owner;Lhaven/Resource;Lhaven/Sprite;Lhaven/Skeleton$BoneOffset;)V Code LineNumberTable ctxres &(Lhaven/Sprite$Owner;)Lhaven/Resource; StackMapTable q { mksprite P(Lhaven/Sprite$Owner;Lhaven/Resource;Lhaven/Message;)Lhaven/res/gfx/fx/eq/Equed; � � � � � mkrlink T(Lhaven/Sprite$Owner;Lhaven/Resource;[Ljava/lang/Object;)Lhaven/res/gfx/fx/eq/Equed; � � added � Slot !(Lhaven/render/RenderTree$Slot;)V tick (D)Z age ()V 
SourceFile 
Equed.java H � A B haven/EquipTarget � � � � � � � C G 	haven/Gob � � java/lang/RuntimeException java/lang/StringBuilder H f no context resource for owner  � � � � � � H � haven/Drawable � � no drawable on object  � � haven/Resource$Resolver Resolver � � � � � � � � � O P � � � haven/Resource � � haven/MessageBuf � � H � � haven/Skeleton$BoneOffset � � No such bone-offset in  � � :  haven/res/gfx/fx/eq/Equed � � H L java/lang/String � � java/lang/Integer � � � � � � � � c � � o [B [Ljava/lang/Object; � haven/RenderLink$ArgLink ArgLink � � � � haven/Sprite haven/Sprite$ResourceException ResourceException !Sublink returned non-sprite node  � � H � � � c d e f � haven/render/RenderTree$Node haven/Sprite$Owner haven/Indir haven/Message haven/render/RenderTree$Slot '(Lhaven/Sprite$Owner;Lhaven/Resource;)V fcontext &(Ljava/lang/Class;Z)Ljava/lang/Object; from 2(Lhaven/EquipTarget;)Ljava/util/function/Supplier; � haven/RUtils$StateTickNode StateTickNode Y(Lhaven/render/RenderTree$Node;Ljava/util/function/Supplier;)Lhaven/RUtils$StateTickNode; context %(Ljava/lang/Class;)Ljava/lang/Object; append -(Ljava/lang/String;)Ljava/lang/StringBuilder; -(Ljava/lang/Object;)Ljava/lang/StringBuilder; toString ()Ljava/lang/String; (Ljava/lang/String;)V getattr "(Ljava/lang/Class;)Lhaven/GAttrib; getres ()Lhaven/Resource; uint16 ()I (I)Lhaven/Indir; uint8 string get ()Ljava/lang/Object; nil Lhaven/Message; bytes (I)[B ([B)V haven/Skeleton layer � IDLayer =(Ljava/lang/Class;Ljava/lang/Object;)Lhaven/Resource$IDLayer; name Ljava/lang/String; create C(Lhaven/Sprite$Owner;Lhaven/Resource;Lhaven/Message;)Lhaven/Sprite; pool Pool Lhaven/Resource$Pool; intValue haven/Resource$Pool load Named +(Ljava/lang/String;I)Lhaven/Resource$Named; haven/Resource$Named indexOf (I)I (Ljava/lang/String;)I haven/RenderLink getcode W(Lhaven/Sprite$Owner;Lhaven/Resource;[Ljava/lang/Object;)Lhaven/render/RenderTree$Node; valueOf &(Ljava/lang/Object;)Ljava/lang/String; %(Ljava/lang/String;Lhaven/Resource;)V add >(Lhaven/render/RenderTree$Node;)Lhaven/render/RenderTree$Slot; haven/render/RenderTree haven/RUtils haven/Resource$IDLayer eq.cjava ! ' 9     A B    C G     H L  M   L     (*+,� *-� **� +�  � � � � �    N            '  	 O P  M   �     Y*� 	 � L+� � 
Y� Y� � *� � � �+� � M,� � 
Y� Y� � +� � � �,� �    Q    � + R� ( S N            +  5  9  T  	 T U  M    	   �*� 	 � ,� �  N,� 6,� :~� 
*� � -�  � :� :~� � Y,,� �  � !:"� #� ":� ,� 
Y� Y� $� � %� &� � � � �� 'Y*+*-�  � � (� )�    Q    � / V WH X�  X Y� ; Z N   .         ! ! " : # ? $ F % W & e ' j ( � ) � [ \  M  �  	  @,2� *N,2� *:+� +,2� *,2� ,� -� .� /� :l� 0� 
:� )1� 2� *� :� 3� 2� 	+:� +:,�� ',2� 4� *� Y,2� 4� 4� !� (:� m,�� \,2� 5� S6� 7� 6*+,2� 5� 5� 8 :� 9� $� :Y� Y� ;� � <� � � =�� 9:� *� � (:"-� #� ":� +� 
Y� Y� $� � %� &� -� � � �� 'Y*+� )�    Q   - 	� > W W X�  X)� T  ]� 	� 
 ^� 9 Z N   ^    -  .  / - 1 7 2 > 3 H 4 Q 5 [ 6 a 8 d : s ; � < � = � > � ? � @ � A � B � D E
 F2 G  _ b  M   (     +*� � > W�    N   
    K  L  c d  M   '     *� '� ?W�    N   
    O 	 P  e f  M   $     *� � @�    N   
    T  U  g    � F   Z  D � E	 I 9 J	 " � K 	 ` � a	   �	 6 � �	 : 9 � 	 n � �	 �  �	 �  � 	 �  �	codeentry A   spr haven.res.gfx.fx.eq.Equed rlink haven.res.gfx.fx.eq.Equed   