void getMinMaxFromTable(){
  float minX = 10000.0;
  float minY = 10000.0;
  float minZ = 10000.0;
  float maxX = -10000.0;
  float maxY = -10000.0;
  float maxZ = -10000.0;
  for (int j=0;j<tableRowsNumber;j++){
    for(int i=0;i<tableColumnNumber;i+=3){
      float x = markersTable.getFloat(j, i);
      float y = markersTable.getFloat(j, i+1);
      float z = markersTable.getFloat(j, i+2);  
      
      if(x>maxX && x!=0)maxX=x;
      if(y>maxY && y!=0)maxY=y;
      if(z>maxZ && z!=0)maxZ=z;
      if(x<minX && x!=0)minX=x;
      if(y<minY && y!=0)minY=y;
      if(z<minZ && z!=0)minZ=z;
    }
  }

  // to different signs in x
  if(minX < 0 && maxX > 0){
    println("yesssss minX < 0 && maxX > 0");
    xCorrection = (abs(minX)+maxX)/2 - maxX;
    xRange = (int)((abs(minX)+maxX)/2);    
  }
  else { 
    xCorrection = 0 - (minX+maxX)/2;
    xRange = (int)xCorrection;
  }


  // y
  if(minY < 0 && maxY > 0){
    println("yesssss minY < 0 && maxY > 0");
    yCorrection = (abs(minY)+maxY)/2 - maxY;
    yRange = (int)((abs(minY)+maxY)/2);
  }
  else { 
    yCorrection = 0 - (minY+maxY)/2;
    yRange = (int)yCorrection;
  }

  // z
  if(minZ < 0 && maxZ > 0){
    println("yesssss minZ < 0 && maxZ > 0");
    zCorrection = (abs(minZ)+maxZ)/2 - maxZ;
    zRange = (int)((abs(minZ)+maxZ)/2);
  }
  else { 
    zCorrection = 0 - (minZ+maxZ)/2;
    zRange = (int)zCorrection;
  }
  xRange=abs(xRange);
  yRange=abs(yRange);
  zRange=abs(zRange);
  println("++++++ RANGES getMinMaxFromTable ++++++");
  println(minX,maxX,xCorrection,xRange);
  println(minY,maxY,yCorrection,yRange);
  println(minZ,maxZ,zCorrection,zRange);

}

void rescaleTableData(){

  // factor to rescale
  float f;

  if(yRange>xRange){
    // we take as ref scale factor defined by yRange to yGlobalRange
    f = float(yGlobalRange)/yRange;
    println("f , yGlobalRange , yRange",f ,yGlobalRange,yRange);

  }else{
    f = float(xGlobalRange)/xRange;
    println("f , xGlobalRange , xRange",f ,xGlobalRange,xRange);
  }

  for (int j=0;j<tableRowsNumber;j++){
    for(int i=0;i<tableColumnNumber;i+=3){
      float x = markersTable.getFloat(j, i);
      float y = markersTable.getFloat(j, i+1);
      float z = markersTable.getFloat(j, i+2);  
      if(!(x ==0 && y==0 && z==0)){


        x = (x+xCorrection)*f;
        y = (y+yCorrection)*f;
        z = (z+zCorrection)*f;

        markersTable.setFloat(j,i,x);
        markersTable.setFloat(j,i+1,y);
        markersTable.setFloat(j,i+2,z);

      } 
    }
  }

  tableRescaled = true;

}

void getBodyFromTable(){
  bodyRef.clear();
  for(int i=0;i<tableColumnNumber;i+=3){
    float x = markersTable.getFloat(currentFrame, i);
    float y = markersTable.getFloat(currentFrame, i+1);
    float z = markersTable.getFloat(currentFrame, i+2);  

    if(!(abs(x) ==0 && abs(y)==0 && abs(z)==0)){
      PVector current = new PVector(x,y,z);  
      bodyRef.add(current);
    } 
  }
  currentFrame = (currentFrame+1) % (tableRowsNumber);
  if (currentFrame==tableRowsNumber) {
    currentFrame = 0;
  } 
}
