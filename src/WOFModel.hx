package;
import tink.pure.*;
using tink.CoreApi;

class WOFModel implements coconut.data.Model {
    @:constant var defaultConfig:Vector<Participant> = [
        {name: "A", chance: 1},
        {name: "B", chance: 50},
        {name: "C", chance: 50},
        {name: "D", chance: 50},
        {name: "E", chance: 1}
    ];
    @:constant var baseConfig:Vector<Participant> = switch js.Cookie.get("config") {
        case null: defaultConfig;
        case v: try (tink.Json.parse(v):Vector<Participant>) catch(e) {
            defaultConfig;
        }
    };

    @:computed var isSpinning:Bool = primedFor.match(Some(_));
    @:observable var primedFor:Option<Participant> = None;
    @:observable var winner:Option<Participant> = None;

    //TODO makes sense to add a persistence here
    @:observable var winners:Vector<Participant> = [];

    @:observable var enabledIndexes:Mapping<Participant, Bool> = [for (k in baseConfig) k => true];
    @:transition function toggleEnabled(p:Participant)
        return {
            enabledIndexes: enabledIndexes.with(p, !enabledIndexes.get(p))
        }

    @:computed var sumChances:Int = {
        var ret = 0;
        for (item in config) ret += item.chance;
        ret;
    }

    @:computed var chancesMap:Mapping<Participant, Float> = [
        for (item in baseConfig)
            item => (enabledIndexes.get(item) ? item.chance / sumChances : 0)
    ];

    @:computed var config:Vector<Participant> = baseConfig.filter(v -> enabledIndexes.get(v));

    @:transition function onSpin()
        return {primedFor: Some(rollItem())};

    @:transition function onSpinComplete()
        return {
            winner: primedFor,
            winners: winners & primedFor.sure(),
            primedFor: None,
        };

    function rollItem():Participant {
        var rnd = Math.random() * sumChances;

        var ret = null;
        var sumProb = 0;
        for (item in config) {
            if (sumProb < rnd && sumProb + item.chance >= rnd) {
                ret = item;
                break;
            } else {
                sumProb += item.chance;
            }
        }
        return ret;
    }
}

typedef Participant = {
    final name:String;
    final chance:Chance;
}

typedef Chance = Int;