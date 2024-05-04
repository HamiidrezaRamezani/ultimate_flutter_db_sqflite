import 'package:flutter/material.dart';

class BookMarkItemsScreen extends StatefulWidget {
  const BookMarkItemsScreen({Key? key}) : super(key: key);

  @override
  State<BookMarkItemsScreen> createState() => _BookMarkItemsScreenState();
}

class _BookMarkItemsScreenState extends State<BookMarkItemsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('علاقه مندی ها'),
      ),
      body: ListView.builder(
          itemCount: 5,
          itemBuilder: (BuildContext context , int index){
        return Directionality(
          textDirection: TextDirection.rtl,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  const Expanded(child: Column(
                    children: [
                      Row(
                        children: [
                          Text('غزل شماره یک')
                        ],
                      ),
                      SizedBox(height: 12.0,),
                      Row(
                        children: [
                          Text('شکفته شد گل حَمرا و گشت بلبل مست')
                        ],
                      )
                    ],
                  )),
                  IconButton(onPressed: (){
                    showDialog(context: context, builder: (BuildContext context){
                      return AlertDialog(
                        backgroundColor: Colors.grey,
                        title: Text('آیا میخواهید این ایتم حذف شود؟'),
                        actions: [
                          ElevatedButton(onPressed: (){}, child: Text('آری')),
                          ElevatedButton(onPressed: (){}, child: Text('خیر')),
                        ],
                      );
                    });
                  }, icon: const Icon(Icons.bookmark))
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
