package;

import mui.core.*;
import js.Browser.*;
import coconut.react.*;
import tink.pure.*;
import tink.state.Observable;
import tink.domspec.Style;
import WOFModel;
using ArrayUtil;
using tink.CoreApi;

class WOFView extends View {
    //set of nice looking colors
    static final COLORS:Array<String> = [
        "#272b66",
        "#2d559f",
        "#9ac147",
        "#639b47",
        "#e1e23b",
        "#f7941e",
        "#662a6c",
        "#9a1d34",
        "#43a1cd",
        "#ba3e2e",
    ];

    @:attr var config:Vector<Participant>;
    @:attr var chancesMap:Mapping<Participant, Float>;
    @:attr var winner:Option<Participant>;
    @:attr var primedFor:Option<Participant>;
    @:attr var isSpinning:Bool;
    @:attr function onSpin():Void;
    @:attr function onSpinComplete():Void;

    @:state var spinStyle:Style = {};

    @:computed var segmentStyle:Style = {
        var shuffledColors = COLORS.shuffle();
        var bgStyle = config.map(v -> {
            var ind = config.indexOf(v);
            var deg = ind * 360 / config.length;
            '${shuffledColors[ind%10]} 0% ${100*(ind+1)/config.length}%';
        }).toArray().toString();
        {
            background: 'radial-gradient(white calc(20% - 1px), transparent 20%), conic-gradient(from 0deg, $bgStyle)',
        }
    }

    function viewDidMount() {
        Observable.auto(() -> primedFor).bind(function(v) switch v {
            case Some(_): animateSpin();
            case _:
        });
    }

    function animateSpin() {
        spinStyle = {};
        var spinTime = Math.random()*1000+2000; //spin 2-3 seconds
        haxe.Timer.delay(onSpinComplete, Math.ceil(spinTime));
        var targetAngle:Float = switch primedFor {
            case Some(v): (Math.random() > 0.5 ? 4 : 3) * 360 - (config.indexOf(v)-0.5) * 360 / config.length; //roll 2-3 full circles
            case None: 0;
        }
        haxe.Timer.delay(function() {
            spinStyle = {
                transform: 'rotate(${targetAngle}deg)',
                transition: '${spinTime/1000}s'
            };
        },0);
    }

    static inline final LABEL_SIZE:Int = 0;
    static inline final WOF_RADIUS:Int = 250;

    function segmentLabelStyle(index:Int, nameLength:Int):Style {
        var angle = 180 - index*360/config.length;
        var rad = angle * Math.PI / 180;
        return {
            left: WOF_RADIUS + WOF_RADIUS * Math.sin(rad) + 'px',
            top: WOF_RADIUS + WOF_RADIUS * Math.cos(rad) + 'px',
            width: LABEL_SIZE + 'px',
            height: LABEL_SIZE + 'px',
            transform: 'rotate(${90 - angle}deg) translate(-${(nameLength+2)*10}px, -45px)'
        }
    }

    function render()
        <div class = "wheel_container">
            <switch $winner>
                <case ${Some(v)}>
                    <Typography variant=${H4} gutterBottom = $true>Winner is <b>${v.name}</b></Typography>
                <case $None>
                    <Typography variant=${H4} gutterBottom = $true>Wheel of Fortune</Typography>
            </switch>
            <div style = $spinStyle>
                <div class = "wheel" style = $segmentStyle>
                    <for ${item in config}>
                        <div class = "wheel_label" style = ${segmentLabelStyle(config.indexOf(item),item.name.length)}>
                            <Typography variant=${H6} style = ${cast {color:"white", inlineSize:"max-content"}}>${item.name}</Typography>
                        </div>
                    </for>
                </div>
            </div>
            <div class = "wheel_pointer" />
            <Button variant=${Outlined} disabled = {isSpinning || config.length <= 1} onClick = ${onSpin}>${winner.match(None) ? "I'm feeling lucky!" : "Spin again"}</Button>
        </div>
    ;
}