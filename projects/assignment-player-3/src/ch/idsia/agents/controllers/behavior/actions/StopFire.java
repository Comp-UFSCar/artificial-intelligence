package ch.idsia.agents.controllers.behavior.actions;

import ch.idsia.agents.controllers.BehaviorTreeAgent;
import ch.idsia.agents.controllers.behavior.BasicTypes.Task;
import ch.idsia.benchmark.mario.engine.sprites.Mario;

/**
 *
 * @author lucasdavid
 */
public class StopFire extends Task {

    @Override
    public boolean run(boolean[] _action, BehaviorTreeAgent _agent) {

        _action[Mario.KEY_SPEED] = false;
        return true;
    }

}
