Haven Resource 1 src <  Contents.java /* Preprocessed source code */
import haven.*;

/* >tt: Contents */
public class Contents implements ItemInfo.InfoFactory {
    public ItemInfo build(ItemInfo.Owner owner, ItemInfo.Raw raw, Object... args) {
	return(new ItemInfo.Contents(owner, ItemInfo.buildinfo(owner, (Object[])args[1])));
    }
}
code �  Contents ����   4 '
    
  
      <init> ()V Code LineNumberTable build   Owner InnerClasses ! Raw O(Lhaven/ItemInfo$Owner;Lhaven/ItemInfo$Raw;[Ljava/lang/Object;)Lhaven/ItemInfo; 
SourceFile Contents.java 	 
 " haven/ItemInfo$Contents Contents [Ljava/lang/Object; # $ 	 % java/lang/Object haven/ItemInfo$InfoFactory InfoFactory haven/ItemInfo$Owner haven/ItemInfo$Raw haven/ItemInfo 	buildinfo ;(Lhaven/ItemInfo$Owner;[Ljava/lang/Object;)Ljava/util/List; )(Lhaven/ItemInfo$Owner;Ljava/util/List;)V 
cont.cjava !         	 
          *� �            �       .     � Y++-2� � � � �                 &    "    	    	    	   	codeentry    tt Contents   