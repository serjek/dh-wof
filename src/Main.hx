package;

import mui.core.*;
import js.Browser.*;
import coconut.react.*;

class Main {
    static function main() {
        Renderer.mount(document.getElementById('app'), <App/>);
    }
}

class App extends View {
    final model = new WOFModel();

    function render()
        <div class = "root">
            <WOFView ${...model} />
            <ParticipantsView ${...model}/>
        </div>
    ;
}