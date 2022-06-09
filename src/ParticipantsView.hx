package;

import mui.core.*;
import js.Browser.*;
import coconut.react.*;
import tink.pure.*;
import WOFModel;

class ParticipantsView extends View {

    @:attr var chancesMap:Mapping<Participant, Float>;
    @:attr var winners:Vector<Participant>;
    @:attr var enabledIndexes:Mapping<Participant, Bool>;
    @:attr function toggleEnabled(p:Participant):Void;

    function render()
        <div style = ${{maxWidth: '400px', paddingLeft: '24px'}}>
            <Table>
                <TableHead>
                <TableRow>
                    <TableCell>Attending</TableCell>
                    <TableCell>Name</TableCell>
                    <TableCell align=$Right>Chance</TableCell>
                    <TableCell align=$Right>Wins</TableCell>
                </TableRow>
                </TableHead>
                <TableBody>
                    <let cnt = ${0}>
                        <for ${item => chance in chancesMap}>
                            <TableRow key={item.name}>
                                <TableCell><Checkbox checked = ${enabledIndexes.get(item)} onChange={() -> toggleEnabled(item)}/></TableCell>
                                <TableCell>${++cnt}. ${item.name}</TableCell>
                                <TableCell align=$Right>${Math.round(chance*10000)/100}%</TableCell>
                                <TableCell align=$Right>${Std.string(winners.filter(v -> v.name == item.name).length)}</TableCell>
                            </TableRow>
                        </for>
                    </let>
                </TableBody>
            </Table>
        </div>
    ;
}