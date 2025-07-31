import 'package:fscore/core/enums/game_etat_enum.dart';

class Fixture {
  final FixtureDetail fixture;
  final League? league;
  final Teams teams;
  final Goals? goals;
  final Score? score;

  Fixture({
    required this.fixture,
    this.league,
    required this.teams,
    this.goals,
    this.score,
  });

  factory Fixture.fromJson(Map<String, dynamic> json) {
    return Fixture(
      fixture: FixtureDetail.fromJson(json['fixture'] as Map<String, dynamic>),
      league: League.fromJson(json['league'] as Map<String, dynamic>),
      teams: Teams.fromJson(json['teams'] as Map<String, dynamic>),
      goals: json['goals'] != null
          ? Goals.fromJson(json['goals'] as Map<String, dynamic>)
          : null,
      score: json['score'] != null
          ? Score.fromJson(json['score'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fixture': fixture.toJson(),
      'league': league?.toJson(),
      'teams': teams.toJson(),
      'goals': goals?.toJson(),
      'score': score?.toJson(),
    };
  }
}

class FixtureDetail {
  final int? id;
  final String? referee;
  final String? timezone;
  final String? date;
  final int? timestamp;
  final Periods? periods;
  final Venue? venue;
  final Status? status;

  FixtureDetail({
    this.id,
    this.referee,
    this.timezone,
    this.date,
    this.timestamp,
    this.periods,
    this.venue,
    this.status,
  });

  String? get dateString =>
      DateTime.tryParse(date ?? '')?.toString().substring(0, 10);
  String? get time =>
      DateTime.tryParse(date ?? '')?.toString().substring(11, 16);

  factory FixtureDetail.fromJson(Map<String, dynamic> json) {
    return FixtureDetail(
      id: json['id'] as int?,
      referee: json['referee'] as String?,
      timezone: json['timezone'] as String?,
      date: json['date'] as String?,
      timestamp: json['timestamp'] as int?,
      periods: json['periods'] != null
          ? Periods.fromJson(json['periods'] as Map<String, dynamic>)
          : null,
      venue: json['venue'] != null
          ? Venue.fromJson(json['venue'] as Map<String, dynamic>)
          : null,
      status: json['status'] != null
          ? Status.fromJson(json['status'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'referee': referee,
      'timezone': timezone,
      'date': date,
      'timestamp': timestamp,
      'periods': periods?.toJson(),
      'venue': venue?.toJson(),
      'status': status?.toJson(),
    };
  }
}

class Periods {
  final int? first;
  final int? second;

  Periods({this.first, this.second});

  factory Periods.fromJson(Map<String, dynamic> json) {
    return Periods(
      first: json['first'] as int?,
      second: json['second'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'first': first,
      'second': second,
    };
  }
}

class Venue {
  final int? id;
  final String? name;
  final String? city;

  Venue({this.id, this.name, this.city});

  factory Venue.fromJson(Map<String, dynamic> json) {
    return Venue(
      id: json['id'] as int?,
      name: json['name'] as String?,
      city: json['city'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'city': city,
    };
  }
}

class Status {
  final String? long;
  final String? short;
  final int? elapsed;
  final int? extra;

  Status({this.long, this.short, this.elapsed, this.extra});

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      long: json['long'] as String?,
      short: json['short'] as String?,
      elapsed: json['elapsed'] as int?,
      extra: json['extra'] as int?,
    );
  }

  get isLive =>
      short == '1H' || short == '2H' || short == 'HT' || short == 'ET';
  get isFinished => short == 'FT' || short == 'FS';
  get isPaused => short == 'PA' || short == 'HT';
  get isCancelled => short == 'C' || short == 'A';

  GameEtat get status {
    switch (short) {
      case 'TBD':
      case 'NS':
        return GameEtat.avant;
      case '1H':
      case '2H':
      case 'ET':
      case 'BT':
      case 'P':
      case 'SUSP':
      case 'INT':
      case 'LIVE':
        return GameEtat.direct;
      case 'HT':
        return GameEtat.pause;
      case 'FT':
      case 'AET':
      case 'PEN':
        return GameEtat.termine;
      case 'PST':
        return GameEtat.reporte;
      case 'CANC':
      case 'ABD':
        return GameEtat.annule;
      case 'AWD':
      case 'WO':
        return GameEtat.avant;
      default:
        return GameEtat.avant;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'long': long,
      'short': short,
      'elapsed': elapsed,
      'extra': extra,
    };
  }
}

class League {
  final int? id;
  final String? name;
  final String? country;
  final String? logo;
  final String? flag;
  final int? season;
  final String? round;

  League({
    this.id,
    this.name,
    this.country,
    this.logo,
    this.flag,
    this.season,
    this.round,
  });

  factory League.fromJson(Map<String, dynamic> json) {
    return League(
      id: json['id'] as int?,
      name: json['name'] as String?,
      country: json['country'] as String?,
      logo: json['logo'] as String?,
      flag: json['flag'] as String?,
      season: json['season'] as int?,
      round: json['round'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'logo': logo,
      'flag': flag,
      'season': season,
      'round': round,
    };
  }
}

class Teams {
  final Team home;
  final Team away;

  Teams({required this.home, required this.away});

  factory Teams.fromJson(Map<String, dynamic> json) {
    return Teams(
      home: Team.fromJson(json['home'] as Map<String, dynamic>),
      away: Team.fromJson(json['away'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home': home.toJson(),
      'away': away.toJson(),
    };
  }
}

class Team {
  final int id;
  final String name;
  final String logo;
  final bool? winner;

  Team({required this.id, required this.name, required this.logo, this.winner});

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] as int,
      name: json['name'] as String,
      logo: json['logo'] as String,
      winner: json['winner'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'logo': logo,
      'winner': winner,
    };
  }
}

class Goals {
  final int? home;
  final int? away;

  Goals({this.home, this.away});

  factory Goals.fromJson(Map<String, dynamic> json) {
    return Goals(
      home: json['home'] as int?,
      away: json['away'] as int?,
    );
  }

  String? get score => home != null && away != null ? '$home-$away' : null;

  Map<String, dynamic> toJson() {
    return {
      'home': home,
      'away': away,
    };
  }
}

class Score {
  final ScorePart? halftime;
  final ScorePart? fulltime;
  final ScorePart? extratime;
  final PenaltyPart? penalty;

  Score({
    this.halftime,
    this.fulltime,
    this.extratime,
    this.penalty,
  });

  String? get score =>
      penalty?.score ?? extratime?.score ?? fulltime?.score ?? halftime?.score;

  factory Score.fromJson(Map<String, dynamic> json) {
    return Score(
      halftime: ScorePart.fromJson(json['halftime'] as Map<String, dynamic>),
      fulltime: ScorePart.fromJson(json['fulltime'] as Map<String, dynamic>),
      extratime: ScorePart.fromJson(json['extratime'] as Map<String, dynamic>),
      penalty: PenaltyPart.fromJson({
        'home': json['penalty']['home'],
        'away': json['penalty']['away'],
        'fulltime': json['fulltime'],
      }),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'halftime': halftime?.toJson(),
      'fulltime': fulltime?.toJson(),
      'extratime': extratime?.toJson(),
      'penalty': penalty?.toJson(),
    };
  }
}

class ScorePart {
  final int? home;
  final int? away;

  ScorePart({this.home, this.away});

  String? get score => home != null && away != null ? '$home-$away' : null;

  factory ScorePart.fromJson(Map<String, dynamic> json) {
    return ScorePart(
      home: json['home'] as int?,
      away: json['away'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home': home,
      'away': away,
    };
  }
}

class PenaltyPart extends ScorePart {
  final ScorePart fulltime;
  PenaltyPart({super.home, super.away, required this.fulltime});

  String? get score => home != null && away != null && fulltime.score != null
      ? '(${home}) ${fulltime.score} (${away})'
      : null;

  factory PenaltyPart.fromJson(Map<String, dynamic> json) {
    return PenaltyPart(
      home: json['home'] as int?,
      away: json['away'] as int?,
      fulltime: ScorePart.fromJson(json['fulltime'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'home': home,
      'away': away,
      'fulltime': fulltime.toJson(),
    };
  }
}
