class Vertex {

  float origX;
  float origY;
  float origZ;

  float distPt;

  float myMinStore;
  float myMaxStore;

  float myX;
  float myY;
  float myZ;

  int id;
  int b;

  boolean allowExpansion;

  float[] myInitDistances = new float[topo[id].length]; //original distances to neighbors
  float[] myMax = new float[topo[id].length];
  float[] myMin = new float[topo[id].length];
  float[] myDistances = new float[topo[id].length]; //live distances to neighbors
  int[] myTally = new int[topo[id].length]; //checks conditions

  Vec3D pushV;
  Vec3D pullV;

  Vertex (float initX, float initY, float initZ, int vertexNum) {

    origX = initX;
    origY = initY;
    origZ = initZ;

    myX = origX;
    myY = origY;
    myZ = origZ;

    id = vertexNum;




    for (int i = 0; i < topo[id].length; i++) { //for all neighbors find distances
      b = topo[id][i];
      myInitDistances[i] = dist(origX, origY, origZ, vector[b].x, vector[b].y, vector[b].z);
      myMax[i] = myInitDistances[i] + delta/2;
      myMin[i] = myInitDistances[i] - delta/2;
      if ( myMin[i] < myMinStore) {
        myMinStore = myMin[i];
      }
      if ( myMax[i] > myMaxStore) {
        myMaxStore = myMax[i];
      }
    }
  }

  void mouseCheck() {

    //check dist to mouse
    distPt = dist(myX, myY, myZ, ptX, ptY, ptZ);

    for (int i = 0; i < topo[id].length; i++) {
      //myMax[i] = myInitDistances[i] + delta/2* (50/distPt);
      //myMin[i] = myInitDistances[i] - delta/2* (50/distPt);
      myMax[i] = myInitDistances[i] + delta/2;
      myMin[i] = myInitDistances[i] - delta/2;
    }



    //find dist to neighbors and chaeck against the max and min
    for (int i = 0; i < topo[id].length; i++) {
      b = topo[id][i];
      myDistances[i] = dist(myX, myY, myZ, vector[b].x, vector[b].y, vector[b].z);
      if (myDistances[i] > myMax[i] ) {
        // create a vector towards neighor
        myTally[i] = 1;
      } else if (myDistances[i] < myMin[i]) {
        //create a vector away from origin
        myTally[i] = 1;
      } else {
        //use mouse displacement vector
        myTally[i] = 0;
      }



      if ( myDistances[i] < globalMin) {
        globalMin = myDistances[i];
      }
      if ( myDistances[i] > globalMax) {
        globalMax = myDistances[i];
      }
    }


    //check tally to create vector
    //tally will be greater than 0 if any limit is reached 
    int checksum = 0;
    for (int i = 0; i < topo[id].length; i++) {
      checksum = myTally[i] + checksum;
    }

    if (checksum > 0) {
      allowExpansion = false;
    } else {
      allowExpansion = true;
    }

    if (distPt < distPtLimit && allowExpansion) { //create vector away from mouse

      pushV = new Vec3D(ptX-myX, ptY-myY, ptZ-myZ);


      pushV.limit(speed);
      myX =  myX - pushV.x;
      myY =  myY - pushV.y;
      myZ =  myZ - pushV.z;
    } else {  //create vector towards Mous

      pullV = new Vec3D(origX-myX, origY-myY, origZ-myZ);

      pullV.limit(speed);
      myX = myX + pullV.x;
      myY = myY + pullV.y;
      myZ= myZ + pullV.z;
    }
  }

  void Display() {



    stroke (100);
    for (int i = 0; i < topo[id].length; i++) {                          //draw a line to neighbors

      int colorInt = 0;

      if (id <= 180 && vertexArray[topo[id][i]].id <= 180) {
        colorInt = 1;
        stroke (87, 214, 217);
      } else if (id <= 180 && vertexArray[topo[id][i]].id > 180) {
        colorInt = 2;
        stroke (240, 226, 186);
      } else if (id > 180 && vertexArray[topo[id][i]].id <= 180) {
        colorInt = 2;
         stroke (240, 226, 186);
      } else if (id > 180 && vertexArray[topo[id][i]].id > 180) {
        colorInt = 3;
        stroke (248, 166, 155);
      } else {
        stroke (0, 0, 0);
      }

      float quickDist = dist(myX, myY, myZ, vertexArray[topo[id][i]].myX, vertexArray[topo[id][i]].myY, vertexArray[topo[id][i]].myZ);
      float colorDelta = abs(quickDist - myInitDistances[i]);

      float weightVal = 1* map(colorDelta, 0, delta, .5, 1.5);
      float colorVal = 2* map(colorDelta, 0, delta, 100, 255);
      //println(colorVal);
      //stroke (colorVal, colorVal, colorVal);
      //stroke (255, 255, 255);
      //strokeWeight(2*weightVal);
      strokeWeight(1.5);
      line (myX, myY, myZ, vertexArray[topo[id][i]].myX, vertexArray[topo[id][i]].myY, vertexArray[topo[id][i]].myZ);
    }

    stroke (100);
    strokeWeight(2);
    point (myX, myY, myZ);
  }
}