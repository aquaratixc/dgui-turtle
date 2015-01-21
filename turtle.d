import dgui.all;
import std.math : sin, cos, fabs;
import std.random : Random, unpredictableSeed, uniform;
import std.array : back, popBack;

/**
 * Authors: Baharew Oleg (aquaratixc), disconnectix@gmail.com
 * Date: 20.01.2015
 * Copyright: Public Domain
 * License: ESL License 1.0
 */


// Состояние исполнителя "черепаха"
// P.S : богатый внутренний мир черепахи
struct turtleState
{
   // координаты "черепахи
   float x;
   float y;
   // угол, на который повернута черепаха перед принятием команд
   float angle;
   // холст, на котором находится черепаха
   Canvas canvas;
   // цвет следа, оставляемого черепахой
   Pen pen;
};


// описание черепахи
// P.S : тут раньше был скелет бронтозавра, но мы подумали и решили, что пусть лучше будет скелет черепахи
class Turtle
{
    private:
        // текущее состояние
        turtleState _state;
        // хранилище под состояния черепахи
        turtleState[] _stack;
        // длина шага
        float _stepLength;
        // приращение угла
        float _angleIncrement;

    // пройти вперед, оставляя след
    void drawStep()
    {
        float newX, newY;
        newX = _state.x + cos(_state.angle) * _stepLength;
        newY = _state.y - sin(_state.angle) * _stepLength;
        _state.canvas.drawLine(_state.pen, cast(int) _state.x, cast(int) _state.y, cast(int) newX, cast(int) newY);
        _state = turtleState(newX, newY, _state.angle, _state.canvas, _state.pen);
    }

    // пройти вперед на шаг случайной длины, оставляя след
    void drawRandomStep()
    {
        float newX, newY, newStep;
        auto gen = Random(unpredictableSeed);
        newStep = uniform(0.0f, _stepLength, gen);
        newX = _state.x + cos(_state.angle) * newStep;
        newY = _state.y - sin(_state.angle) * newStep;
        _state.canvas.drawLine(_state.pen, cast(int) _state.x, cast(int) _state.y, cast(int) newX, cast(int) newY);
        _state = turtleState(newX, newY, _state.angle, _state.canvas, _state.pen);
    }

    // пройти вперед на шаг, не оставляя след
    void moveStep()
    {
        float newX, newY;
        newX = _state.x + cos(_state.angle) * _stepLength;
        newY = _state.y - sin(_state.angle) * _stepLength;
        _state = turtleState(newX, newY, _state.angle, _state.canvas, _state.pen);
    }

    // пройти вперед на шаг случайной длины, не оставляя след
    void moveRandomStep()
    {
        float newX, newY, newStep;
        auto gen = Random(unpredictableSeed);
        newStep = uniform(0.0f, _stepLength, gen);
        newX = _state.x + cos(_state.angle) * newStep;
        newY = _state.y - sin(_state.angle) * newStep;
        _state = turtleState(newX, newY, _state.angle, _state.canvas, _state.pen);
    }

    // поворот влево на величину приращения
    void rotateLeft()
    {
        float newAngle;
        newAngle = _state.angle + _angleIncrement;
        _state = turtleState(_state.x, _state.y, newAngle, _state.canvas, _state.pen);
    }

    // поворот вправо на величину приращения
    void rotateRight()
    {
        float newAngle;
        newAngle = _state.angle - _angleIncrement;
        _state = turtleState(_state.x, _state.y, newAngle, _state.canvas, _state.pen);
    }

    // поворот на случайную величину приращения
    void rotateRandom()
    {
        float newAngle;
        auto gen = Random(unpredictableSeed);
        newAngle = uniform(-fabs(_state.angle), fabs(_state.angle), gen);
        _state = turtleState(_state.x, _state.y, newAngle, _state.canvas, _state.pen);
    }

    // сохранить текущее состояние черепахи
    void saveState()
    {
        _stack ~= _state;
    }

    // восстановить последнее сохраненное состояние
    void restoreState()
    {
        _state = _stack.back();
        _stack.popBack();
    }

    // передать черепахе серию команд
    // P.S : отобразить результаты пыток, примененных к черепахе
    public void draw(string turtleCommands)
    {
        foreach (command; turtleCommands)
        {
            switch(command) {
            case 'F':
                drawStep();
                break;
            case 'f':
                moveStep();
                break;
            case 'R':
                drawRandomStep();
                break;
            case 'r':
                moveRandomStep();
                break;
            case '+':
                rotateRight();
                break;
            case '-':
                rotateLeft();
                break;
            case '?':
                rotateRandom();
                break;
            case '[':
                saveState();
                break;
            case ']':
                restoreState();
                break;
            default:
                break;
            }
        }
    }

    // конструктор класса
    // параметры см. в секции private
    // P.S : конструктор кибер-черепах
    public this(turtleState state, float stepLength, float angleIncrement)
    {
        _state = state;
        _stepLength = stepLength;
        _angleIncrement = angleIncrement;
    }

    // вернуть текущее состояние черепахи
    // P.S : иногда даже кот Шредингера нервно курит в сторонке ...
    @property turtleState getState()
    {
        return _state;
    }

    // изменить длину шага
    public void changeStepLength(float stepLength)
    {
        _stepLength = stepLength;
    }

    // изменить приращение угла
    public void changeAngleIncrement(float angleIncrement)
    {
        _angleIncrement = angleIncrement;
    }

    // изменить текущее состояние черепахи мануально
    // P.S : наследить в душу черепахи
    public void changeState(turtleState state)
    {
        _state = state;
    }

    // загрузить в текущую черепаху другую черепаху
    // P.S : не знаю, зачем надо, но пусть иногда используется
    public void load(Turtle turtle)
    {
        _state = turtle.getState;
    }

    // клонировать черепаху со всем ее состоянием
    // P.S : черепаха содержит ГМО
    public Turtle clone()
    {
        return new Turtle(_state, _stepLength, _angleIncrement);
    }
};

