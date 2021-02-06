
import 'package:flutter/material.dart';
import 'package:neatease_app/screen/components/list_title.dart';

class SearchPage extends SearchDelegate<String> {
  String searchHint = "搜索音乐、歌词、电台";
  //接受服务器端返回的建议
  List<String> suggestionCardTitle = [
    '动物世界',
    '梁博',
    '清明雨上',
    '皮皮虾我们走',
    '进击的巨人',
    '极乐净土',
    '张国荣',
    '烟鬼',
    '周杰伦',
    '陈奕迅',
  ];
  List<Widget> buildSuggestionCard(BuildContext context) {
    List<Widget> list = [];
    for (var title in suggestionCardTitle) {
      list.add(buildSearchSuggestionCard(context,title));
    }
    return list;
  }

  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

/*这个方法返回一个控件，显示为搜索框左侧的按钮，一般设置为返回，这里返回一个具有动态效果的返回按钮：*/
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow, progress: transitionAnimation),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text('12312321'),
    );
  }

/*这个方法返回一个控件，显示为搜索内容区域的建议内容。*/
  @override
  Widget buildSuggestions(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: <Widget>[
          Divider(),
          NeteaseListTitle(
            title: '歌手分类',
            fontSize: 20,
            press: () {},
          ),
          Divider(),
          NeteaseListTitle(
            title: '热门搜索',
            fontSize: 17,
          ),
          //流布局

          Wrap(
            children: buildSuggestionCard(context),
          ),
        ],
      ),
    );
  }

/*这个方法返回一个主题，也就是可以自定义搜索界面的主题样式：*/
  @override
  ThemeData appBarTheme(BuildContext context) {
    // TODO: implement appBarTheme
    return super.appBarTheme(context);
  }

  Widget buildSearchSuggestionCard(BuildContext context,String title) {
    return InkWell(
      onTap: () {
        query = title;
        showResults(context);
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            margin: EdgeInsets.fromLTRB(10.0, 5, 0, 5.0),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: Colors.grey,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 200.0),
              child: Text(
                '$title',
                style: TextStyle(
                  fontSize: 17,
                ),
                softWrap: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
