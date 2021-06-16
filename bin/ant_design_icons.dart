import 'dart:convert';
import 'dart:io';

void main() async {
  await Directory('asset').create();
  var output = "import 'package:flutter/widgets.dart';";
  output += generateIconDataClass('filled');
  output += generateIconDataClass('outlined');
  output += '''
    /// Identifiers for the ant design icons.
    ///
    /// Use with the [Icon] class to show specific icons.
    ///
    /// See also:
    ///
    ///  * [Icon]
    ///  * [IconButton]
    ///  * <https://ant.design/components/icon/>
    class AntdIcons {
  ''';
  output += await generateFont('filled');
  output += await generateFont('outlined');
  output += '}';
  const outputFile = 'lib/ant_design_icons.dart';
  await File(outputFile).writeAsString(output);
  await formatDartFile(outputFile);
}

Future<String> generateFont(String type) async {
  final name = '${type}_antd_icons';
  final result = await Process.run('npx', [
    'fantasticon',
    'node_modules/@ant-design/icons-svg/inline-svg/$type',
    '-o',
    'asset',
    '-t',
    'ttf',
    '-n',
    name,
  ]);
  print(result.stdout);
  final file = File('asset/$name.json');
  Map<String, dynamic> json = jsonDecode(await file.readAsString());
  var output = '';
  var icons = '''
    import 'package:ant_design_icons/ant_design_icons.dart';
    const ${type}Icons = [
  ''';
  json.forEach((key, value) {
    final name = '${key.replaceAll('-', '_')}_$type';
    output +=
        'static const IconData $name = ${upperFirst(type)}AntdIconsData($value);';
    icons += "[AntdIcons.$name, '$name'],";
  });
  icons += '];';
  final iconsFile = 'example/lib/$type.dart';
  await File(iconsFile).writeAsString(icons);
  await formatDartFile(iconsFile);
  return output;
}

String generateIconDataClass(String type) {
  type = upperFirst(type);
  return '''
    class ${type}AntdIconsData extends IconData {
      const ${type}AntdIconsData(int code)
          : super(
              code,
              fontFamily: '${type}AntdIcons',
              fontPackage: 'ant_design_icons',
          );
    }
  ''';
}

String upperFirst(String s) {
  return s[0].toUpperCase() + s.substring(1);
}

Future<void> formatDartFile(String path) {
  return Process.run(
    'flutter${Platform.isWindows ? '.bat' : ''}',
    ['format', path],
  );
}
