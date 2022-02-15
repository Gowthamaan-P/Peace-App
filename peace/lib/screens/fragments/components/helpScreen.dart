import 'package:flutter/material.dart';
import 'package:peace/dataBaseProviders/faqProvider.dart';
import 'package:peace/helpers/responsiveTable/dataTableHeader.dart';
import 'package:peace/helpers/responsiveTable/responsiveDataTable.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({Key? key}) : super(key: key);

  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {

  late bool isReady;
  List<DatatableHeader> _headers = [
    DatatableHeader(
        text: "Questions",
        value: "question",
        show: true,
        flex: 2,
        sortable: true,
        textAlign: TextAlign.center)
  ];

  List<int>? _perPages = [10, 20, 50, 100];
  int _total = 100;
  int _currentPerPage = 10;
  List<bool> _expanded = [];
  String _searchKey = "question";

  Widget _dropContainer(data) {

    return Container(
      height: (MediaQuery.of(context).size.height)*0.1,
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.all(10.0),
      color: Colors.blue.shade50,
      child: ListView(
        children: [
          Text(
            "${data["answer"]}",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: (MediaQuery.of(context).size.height) * 0.04,
                color: Colors.black,
                height: 1,
            ),
          ),
        ],
      ),
    );
  }

  int _currentPage = 1;
  bool _isSearch = false;
  List<Map<String, dynamic>> _sourceOriginal = [];
  List<Map<String, dynamic>> _sourceFiltered = [];
  List<Map<String, dynamic>> _source = [];
  List<Map<String, dynamic>> _selected = [];

  String? _sortColumn;
  bool _sortAscending = true;
  bool _isLoading = true;
  bool _showSelect = false;

  @override
  void initState() {
    isReady = false;
    _mockPullData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Column(
        children: <Widget>[
          Container(
            height: 70,
            alignment: Alignment.center,
            color: Colors.lightBlue.shade900,
            child: Row(
              children: <Widget>[
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.chevron_left_rounded,
                      color: Colors.white,
                      size: height*0.04,
                    )),
                Text(
                  'Help & FAQ',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: height*0.05,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: height-136,
            margin: EdgeInsets.all(10),
            child: Card(
              elevation: 1,
              shadowColor: Colors.black,
              clipBehavior: Clip.none,
              child: ResponsiveDatatable(
                title: null,
                actions: [
                  if (_isSearch)
                    Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: "Enter the keywords to search",
                              hintStyle: TextStyle(fontSize: 18),
                              prefixIcon: IconButton(
                                  icon: Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      _isSearch = false;
                                    });
                                  }),
                              suffixIcon: IconButton(
                                  icon: Icon(Icons.search), onPressed: () {})),
                          onSubmitted: (value) {
                            _filterData(value);
                          },
                        )),
                  if (!_isSearch)
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _isSearch = true;
                          });
                        })
                ],
                headers: _headers,
                source: _source,
                selected: _selected,
                showSelect: _showSelect,
                autoHeight: false,
                isExpandRows: true,
                dropContainer: _dropContainer,
                onTabRow: (data) {},
                onSort: (value) {
                  setState(() => _isLoading = true);

                  setState(() {
                    _sortColumn = value;
                    _sortAscending = !_sortAscending;
                    if (_sortAscending) {
                      _sourceFiltered.sort((a, b) =>
                          b["$_sortColumn"].compareTo(a["$_sortColumn"]));
                    } else {
                      _sourceFiltered.sort((a, b) =>
                          a["$_sortColumn"].compareTo(b["$_sortColumn"]));
                    }
                    var _rangeTop = _currentPerPage < _sourceFiltered.length
                        ? _currentPerPage
                        : _sourceFiltered.length;
                    _source = _sourceFiltered.getRange(0, _rangeTop).toList();
                    _searchKey = value;

                    _isLoading = false;
                  });
                },
                expanded: _expanded,
                sortAscending: _sortAscending,
                sortColumn: _sortColumn,
                isLoading: _isLoading,
                onSelect: (value, item) {
                  print("$value  $item ");
                  if (value) {
                    setState(() => _selected.add(item));
                  } else {
                    setState(
                            () => _selected.removeAt(_selected.indexOf(item)));
                  }
                },
                onSelectAll: (value) {
                  if (value) {
                    setState(() => _selected =
                        _source.map((entry) => entry).toList().cast());
                  } else {
                    setState(() => _selected.clear());
                  }
                },
                footers: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text("Rows per page:", style: TextStyle(fontSize: 18),),
                  ),
                  if (_perPages != null)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      child: DropdownButton(
                          value: _currentPerPage,
                          items: _perPages!
                              .map((e) => DropdownMenuItem(
                            child: Text("$e"),
                            value: e,
                          ))
                              .toList(),
                          onChanged: (int? value) {
                            setState(() {
                              _currentPerPage = value!;
                              _currentPage = 1;
                              _resetData();
                            });
                          }),
                    ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text("$_currentPage - $_currentPerPage of $_total", style: TextStyle(fontSize: 20),),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      size: 16,
                    ),
                    onPressed: _currentPage == 1
                        ? null
                        : () {
                      var _nextSet = _currentPage - _currentPerPage;
                      setState(() {
                        _currentPage = _nextSet > 1 ? _nextSet : 1;
                        _resetData(start: _currentPage - 1);
                      });
                    },
                    padding: EdgeInsets.symmetric(horizontal: 5),
                  ),
                  IconButton(
                    icon: Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: _currentPage + _currentPerPage - 1 > _total
                        ? null
                        : () {
                      var _nextSet = _currentPage + _currentPerPage;

                      setState(() {
                        _currentPage = _nextSet < _total
                            ? _nextSet
                            : _total - _currentPerPage;
                        _resetData(start: _nextSet - 1);
                      });
                    },
                    padding: EdgeInsets.symmetric(horizontal: 10),
                  )
                ],
              ),
            ),
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Puducherry Technological University',
              style: TextStyle(
                color: Colors.grey,
                fontSize: height*0.025,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<List<Map<String, dynamic>>> getProductList() async {
    List<Map<String, dynamic>> temps = [];
    List<FaqModel> faq = await FaqController().getFaqList();
    faq.removeLast();
    faq.forEach((element) {
      temps.add({
        'question': element.question,
        'answer': element.answer
      });
    });
    return temps;
  }

  _mockPullData() async {
    _expanded = List.generate(_currentPerPage, (index) => false);
    if (mounted) {
      setState(() => _isLoading = true);
    }
    Future.delayed(Duration(seconds: 3)).then((value) async {
      _sourceOriginal.clear();
      _sourceOriginal.addAll(await getProductList());
      _sourceFiltered = _sourceOriginal;
      _total = _sourceFiltered.length;
      _source = _sourceFiltered
          .getRange(
          0,
          (_sourceFiltered.length > _currentPerPage)
              ? _currentPerPage
              : _sourceFiltered.length)
          .toList();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  _resetData({start: 0}) async {
    if (mounted) {
      setState(() => _isLoading = true);
    }
    var _expandedLen =
    _total - start < _currentPerPage ? _total - start : _currentPerPage;
    Future.delayed(Duration(seconds: 0)).then((value) {
      _expanded = List.generate(_expandedLen.toInt(), (index) => false);
      _source.clear();
      _source = _sourceFiltered.getRange(start, start + _expandedLen).toList();
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  _filterData(value) {
    if (mounted) {
      setState(() => _isLoading = true);
    }
    try {
      if (value == "" || value == null) {
        _sourceFiltered = _sourceOriginal;
      } else {
        _sourceFiltered = _sourceOriginal
            .where((data) => data[_searchKey]
            .toString()
            .toLowerCase()
            .contains(value.toString().toLowerCase()))
            .toList();
      }

      _total = _sourceFiltered.length;
      var _rangeTop = _total < _currentPerPage ? _total : _currentPerPage;
      _expanded = List.generate(_rangeTop, (index) => false);
      _source = _sourceFiltered.getRange(0, _rangeTop).toList();
    } catch (e) {
      print(e);
    }
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}
