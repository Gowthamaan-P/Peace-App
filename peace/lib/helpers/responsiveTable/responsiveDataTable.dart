import 'package:flutter/material.dart';
import 'dataTableHeader.dart';

class ResponsiveDatatable extends StatefulWidget {
  final bool showSelect;
  final List<DatatableHeader>? headers;
  final List<Map<String, dynamic>>? source;
  final List<Map<String, dynamic>>? selected;
  final Widget? title;
  final List<Widget>? actions;
  final List<Widget>? footers;
  final Function(bool value)? onSelectAll;
  final Function(bool value, Map<String, dynamic> data)? onSelect;
  final Function(dynamic value)? onTabRow;
  final Function(dynamic value)? onSort;
  final String? sortColumn;
  final bool? sortAscending;
  final bool isLoading;
  final bool autoHeight;
  final bool hideUnderline;
  final bool commonMobileView;
  final bool isExpandRows;
  final List<bool>? expanded;
  final Function? dropContainer;

  const ResponsiveDatatable(
      {Key? key,
        this.showSelect: false,
        this.onSelectAll,
        this.onSelect,
        this.onTabRow,
        this.onSort,
        this.headers,
        this.source,
        this.selected,
        this.title,
        this.actions,
        this.footers,
        this.sortColumn,
        this.sortAscending,
        this.isLoading: false,
        this.autoHeight: true,
        this.hideUnderline: true,
        this.commonMobileView: true,
        this.isExpandRows:true,
        this.expanded,
        this.dropContainer})
      : super(key: key);

  @override
  _ResponsiveDatatableState createState() => _ResponsiveDatatableState();
}

class _ResponsiveDatatableState extends State<ResponsiveDatatable> {
  Widget mobileHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Checkbox(
            value: widget.selected!.length == widget.source!.length &&
                widget.source != null &&
                widget.source!.length > 0,
            onChanged: (value) {
              if (widget.onSelectAll != null) widget.onSelectAll!(value!);
            }),
        PopupMenuButton(
            child: Container(
              padding: EdgeInsets.all(15),
              child: Text("SORT BY"),
            ),
            tooltip: "SORT BY",
            initialValue: widget.sortColumn,
            itemBuilder: (_) => widget.headers!
                .where(
                    (header) => header.show == true && header.sortable == true)
                .toList()
                .map((header) => PopupMenuItem(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "${header.text}",
                    style: TextStyle(fontWeight: FontWeight.w700),
                    textAlign: header.textAlign,
                  ),
                  if (widget.sortColumn != null &&
                      widget.sortColumn == header.value)
                    widget.sortAscending!
                        ? Icon(Icons.arrow_downward, size: 15)
                        : Icon(Icons.arrow_upward, size: 15)
                ],
              ),
              value: header.value,
            ))
                .toList(),
            onSelected: (value) {
              if (widget.onSort != null) widget.onSort!(value);
            })
      ],
    );
  }
 List<Widget> mobileList() {
    return widget.source!.map((data) {
      return InkWell(
        onTap: widget.onTabRow != null
            ? () {
          widget.onTabRow!(data);
        }
            : null,
        child: Container(
          decoration: BoxDecoration(
              border: Border(
                  bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Spacer(),
                  if (widget.showSelect && widget.selected != null)
                    Checkbox(
                        value: widget.selected!.indexOf(data) >= 0,
                        onChanged: (value) {
                          if (widget.onSelect != null)
                            widget.onSelect!(value!, data);
                        }),
                ],
              ),
              if(widget.commonMobileView)widget.dropContainer!(data),
              if(!widget.commonMobileView)...widget.headers!
                  .where((header) => header.show == true)
                  .toList()
                  .map(
                    (header) => Container(
                  padding: EdgeInsets.all(11),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      header.headerBuilder != null
                          ? header.headerBuilder!(header.value)
                          : Text(
                        "${header.text}",
                        overflow: TextOverflow.clip,
                      ),
                      Spacer(),
                      header.sourceBuilder != null
                          ? header.sourceBuilder!(data[header.value], data)
                          : header.editable
                          ? editAbleWidget(
                        data: data,
                        header: header,
                        textAlign: TextAlign.end,
                      )
                          : Text("${data[header.value]}")
                    ],
                  ),
                ),
              )
                  .toList()
            ],
          ),
        ),
      );
    }).toList();
  }

  Alignment headerAlignSwitch(TextAlign textAlign) {
    switch (textAlign) {
      case TextAlign.center:
        return Alignment.center;
      case TextAlign.left:
        return Alignment.centerLeft;
      case TextAlign.right:
        return Alignment.centerRight;
      default:
        return Alignment.center;
    }
  }

  Widget desktopHeader() {
    return Container(
      decoration: BoxDecoration(
          border:
          Border(bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.showSelect && widget.selected != null)
            Checkbox(
                value: widget.selected!.length == widget.source!.length &&
                    widget.source != null &&
                    widget.source!.length > 0,
                onChanged: (value) {
                  if (widget.onSelectAll != null) widget.onSelectAll!(value!);
                }),
          ...widget.headers!
              .where((header) => header.show == true)
              .map(
                (header) => Expanded(
                flex: header.flex,
                child: InkWell(
                  onTap: () {
                    if (widget.onSort != null && header.sortable)
                      widget.onSort!(header.value);
                  },
                  child: header.headerBuilder != null
                      ? header.headerBuilder!(header.value)
                      : Container(
                    padding: EdgeInsets.all(11),
                    alignment: headerAlignSwitch(header.textAlign),
                    child: Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          "${header.text}",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w700
                          ),
                          textAlign: header.textAlign,
                        ),
                        if (widget.sortColumn != null &&
                            widget.sortColumn == header.value)
                          widget.sortAscending!
                              ? Icon(Icons.arrow_downward, size: 15)
                              : Icon(Icons.arrow_upward, size: 15)
                      ],
                    ),
                  ),
                )),
          )
              .toList()
        ],
      ),
    );
  }

  List<Widget> desktopList() {
    List<Widget> widgets = [];
    for (var index = 0; index < widget.source!.length; index++) {
      final data = widget.source![index];
      widgets.add(Column(
        children: [
          InkWell(
            onTap: () {
              widget.onTabRow!(data);
              setState(() {
                widget.expanded![index] = !widget.expanded![index];
              });
            },
            child: Container(
              padding: EdgeInsets.all(widget.showSelect ? 0 : 5),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1))),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.showSelect && widget.selected != null)
                    Row(
                      children: [
                        Checkbox(
                            value: widget.selected!.indexOf(data) >= 0,
                            onChanged: (value) {
                              if (widget.onSelect != null)
                                widget.onSelect!(value!, data);
                            }),
                        // RaisedButton(onPressed: (){
                        //   setState(() {
                        //     widget.expanded[widget.selecteds.indexOf(data)] = true;
                        //   });
                        // },
                        // child: Text("Drop"),)
                      ],
                    ),
                  ...widget.headers!
                      .where((header) => header.show == true)
                      .map(
                        (header) => Expanded(
                      flex: header.flex,
                      child: header.sourceBuilder != null
                          ? header.sourceBuilder!(data[header.value], data)
                          : header.editable
                          ? editAbleWidget(
                        data: data,
                        header: header,
                        textAlign: header.textAlign,
                      )
                          : Container(
                        padding: EdgeInsets.symmetric(horizontal: 2),
                        child: widget.isExpandRows? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${data[header.value]}",
                              textAlign: header.textAlign,
                              softWrap: true,
                              maxLines: 10,
                              style: TextStyle(
                                fontSize: (MediaQuery.of(context).size.height)*0.04
                              ),
                            ),
                            Icon(Icons.arrow_drop_down_sharp, size: (MediaQuery.of(context).size.height)*0.035)
                          ],
                        ):Text(
                          "${data[header.value]}",
                          textAlign: header.textAlign,
                          softWrap: true,
                          maxLines: 10,
                          style: TextStyle(
                              fontSize: (MediaQuery.of(context).size.height)*0.04
                          ),
                        ),
                      ),
                    ),
                  )
                      .toList()
                ],
              ),
            ),
          ),
          if(widget.isExpandRows && widget.expanded![index])widget.dropContainer!(data)
        ],
      ));
    }
    return widgets;
  }

  Widget editAbleWidget({
    @required Map<String, dynamic>? data,
    @required DatatableHeader? header,
    TextAlign textAlign: TextAlign.center,
  }) {
    return Container(
      constraints: BoxConstraints(maxWidth: 150),
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(0),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(0),
          border: this.widget.hideUnderline
              ? InputBorder.none
              : UnderlineInputBorder(borderSide: BorderSide(width: 1)),
          alignLabelWithHint: true,
        ),
        textAlign: textAlign,
        controller: TextEditingController.fromValue(
          TextEditingValue(text: "${data![header!.value]}"),
        ),
        onChanged: (newValue) => data[header.value] = newValue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          //title and actions
          if (widget.title != null || widget.actions != null)
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300))),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (widget.title != null) widget.title!,
                  if (widget.actions != null) ...widget.actions!
                ],
              ),
            ),

          //desktopHeader
          if (widget.headers != null && widget.headers!.isNotEmpty)
            desktopHeader(),

          if (widget.isLoading) LinearProgressIndicator(),

          if (widget.autoHeight) Column(children: desktopList()),

          if (!widget.autoHeight)
          // desktopList
            if (widget.source != null && widget.source!.isNotEmpty)
              Expanded(
                  child: Container(
                      child: ListView(children: desktopList()))),

          //footer
          if (widget.footers != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [...?widget.footers],
            )
        ],
      ),
    );
  }
}