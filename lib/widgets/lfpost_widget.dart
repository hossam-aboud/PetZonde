import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:petzone/model/adoption_post.dart';
import 'package:petzone/model/lost_and_found.dart';

class lostAndFoundWidget extends StatelessWidget {

  final lostAndFoundPost pet;
  final Widget nextPage;

  lostAndFoundWidget({required this.pet, required this.nextPage});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => nextPage),
        );
      },
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(
              color: Colors.grey[200]!,
              width: 1,
            ),
            boxShadow: [BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 7,
              offset: Offset(0,3),
            )]
        ),
        margin: EdgeInsets.only(right:12 , left: 12 , bottom: 12),
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: pet.imgUrl.isEmpty ? AssetImage('assets/pet_profile_picture.png') as ImageProvider: NetworkImage(pet.imgUrl[0]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(12)
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.fromLTRB(10, 8, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
  Container(
    decoration: BoxDecoration(
      color: pet.status != 'open' ? Colors.blueGrey[100]: pet.type == "Lost" ? Colors.red[100] : Colors.green[100],
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    child: Text(
      pet.type,
      style: TextStyle(
        color: pet.status != 'open' ? Colors.black45 : pet.type == "Lost" ? Colors.red : Colors.blueGrey,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    ),
  ),
Icon(pet.status == 'open' ? null : Icons.lock_outline, size: 20,)
],),

                  SizedBox(
                    height: 8,
                  ),


                  Row(
                    children: [

                      Icon(
                        Icons.location_on,
                        color: Colors.grey[600],
                        size: 18,
                      ),

                      SizedBox(
                        width: 4,
                      ),

Flexible(child:
Container(child:                       Text(
  pet.user == null ? pet.address :pet.distance.toString() + ' m away' ,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    color: Colors.grey[600],
    fontSize: 12,
  ),
),
    )),
                      SizedBox(
                        width: 4,
                      ),

                    ],
                  ),

                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}