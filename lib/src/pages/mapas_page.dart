import 'package:flutter/material.dart';
import 'package:qrreaderapp/src/bloc/scans_bloc.dart';
import 'package:qrreaderapp/src/models/scan_model.dart';
import 'package:qrreaderapp/src/util/utils.dart' as utils;

class MapasPage extends StatefulWidget {
  final String scanType;
  MapasPage( { this.scanType });

  @override
  _MapasPageState createState() => _MapasPageState();
}

class _MapasPageState extends State<MapasPage> {
  final scansBloc = new ScansBloc();
  Stream<List<ScanModel>> scanStream;
  IconData iconData;

  @override
  Widget build(BuildContext context) {
    _determineStreamAndIcon();

    scansBloc.obtenerScans();
    return StreamBuilder<List<ScanModel>>(
      stream: scanStream,
      builder: (BuildContext context, AsyncSnapshot<List<ScanModel>> snapshot) {
        if( !snapshot.hasData ){
          return Center(child: CircularProgressIndicator());
        }

        final scans = snapshot.data;

        if(scans.length == 0){
          return Center(
            child: Text('No hay informacion'),
          );
        } 

        return ListView.builder(
          itemCount: scans.length,
          itemBuilder: (context, i) => Dismissible(
            key: UniqueKey(),
            background: Container( color: Colors.red),
            onDismissed: (direction) => scansBloc.borrarScan(scans[i].id),
            child: ListTile(
              leading: Icon( iconData, color: Theme.of(context).primaryColor),
              title: Text(scans[i].valor),
              subtitle: Text( 'ID:  ${scans[i].id.toString()}  - TIPO: ${scans[i].tipo}'),
              trailing: Icon( Icons.keyboard_arrow_right),
              onTap: () => utils.abrirScan(context, scans[i]),
            ),
          )
        );
        
      },
    );
  }

   _determineStreamAndIcon() {
    if (widget.scanType == 'geo') {
      scanStream = scansBloc.scansStream;
      iconData = Icons.map;
    } else if (widget.scanType == 'http') {
      scanStream = scansBloc.scansStreamHttp;
      iconData = Icons.link;
    }
    setState(() {});
  }
}