class Landkreis{
  String name;
  Landkreis(this.name){ }

  String get kreis{
    if(name.contains("/")){
      return name.split("/")[0];
    }
  }
  String get subkreis{
    if(name.contains("/")){
      return name.split("/")[1];
    }
  }

}