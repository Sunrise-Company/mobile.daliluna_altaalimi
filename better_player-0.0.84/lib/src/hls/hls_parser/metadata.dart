import 'package:better_player/src/hls/hls_parser/hls_track_metadata_entry.dart';
import 'package:collection/collection.dart';

class Metadata {
  Metadata(this.list);

  final List<HlsTrackMetadataEntry> list;

  @override
  // ignore: non_nullable_equals_parameter
  bool operator ==(dynamic other) {
    if (other is Metadata) {
      return const ListEquality<HlsTrackMetadataEntry>()
          .equals(other.list, list);
    }
    return false;
  }

  @override
  int get hashCode => list.hashCode;
}
