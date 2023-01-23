package generics;

import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup.FlxTypedSpriteGroup;
import flixel.util.FlxSave;

class Window extends FlxTypedSpriteGroup<FlxSprite> {
    //no text or symbols, just window!
    var sprites:Array<FlxSprite> = [];
    var enterMask:FlxSprite;
    var _width:Int;
    var _height:Int;
    public function new(x:Float, y:Float, __width:Int, __height:Int, ?palette:Int = 255) {
        super(x,y,0);
        _width = __width;
        _height = __height;

        for (i in 0...__width+1) {
            for (j in 0...__height+1) {
                var sprite = new FlxSprite(8*i, 8*j).loadGraphic(Pathfinder.image('MENU/WINDOW'), true, 8, 8);
                var frame:Int = 255;
                //top left
                if (sprite.x == 0 && sprite.y == 0) frame = 16;
                //top looping
                if (sprite.y == 0 && sprite.x > 0 && sprite.x < __width*8) frame = 17;
                //top right
                if (sprite.y == 0 && sprite.x == __width*8) frame = 18;
                //left looping
                if (sprite.x == 0 && sprite.y > 0 && sprite.y < __height*8) frame = 11;
                //right looping
                if (sprite.x == __width*8 && sprite.y > 0 && sprite.y < __height*8) frame = 12;
                //bottom right
                if (sprite.x == __width*8 && sprite.y == __height*8) frame = 15;
                //bottom left
                if (sprite.x == 0 && sprite.y == __height*8) frame = 13;
                //bottom looping
                if (sprite.y == __height*8 && sprite.x > 0 && sprite.x < __width*8) frame = 14;
                switch(frame) {
                    case 255:
                        if (sprite.x == 8 && sprite.y == 8) {
                            sprite.setGraphicSize((__width*8)-8, (__height*8)-8);
                            sprite.updateHitbox();
                        } else {
                            remove(sprite, true);
                            sprite.destroy();
                            continue;
                        }
                    case 14 | 17:
                        if (sprite.x == 8) {
                            sprite.setGraphicSize((__width*8)-8, 8);
                            sprite.updateHitbox();
                        } else {
                            remove(sprite, true);
                            sprite.destroy();
                            continue;
                        }
                    case 11 | 12:
                        if (sprite.y == 8) {
                            sprite.setGraphicSize(8, (__height*8)-8);
                            sprite.updateHitbox();
                        } else {
                            remove(sprite, true);
                            sprite.destroy();
                            continue;
                        }
                }
                sprite.animation.add('anim', [frame], 24);
                sprite.animation.play('anim', true);
                sprites.push(sprite);
                sprite.active = false;
                add(sprite);
            }
        }

        setPalette(palette);
    }

    override function update(elapsed) {
        x = Math.round(x);
        y = Math.round(y);
        if (entering) {
            frameStep++;
            if (frameStep % enterSpeed == 0) {
                for (sprite in sprites) {
                    if (FlxG.overlap(sprite, enterMask))
                        sprite.visible = false;
                    else
                        sprite.visible = true;
                }
                enterMask.y += 8.1;
                if (enterMask.y > (_height*8)+5) {
                    entering = false;
                    enterMask.kill();
                    enterMask.destroy();
                    for (sprite in sprites)
                        sprite.visible = true;
                }
            }
        }
    }

    public function setPalette(palette:Int, ?_save:Int = 0) {
        if (palette == 255) return;
        var save:FlxSave = new FlxSave();
		save.bind('srm$_save');
        switch (palette) {
            case 0:
                for (sprite in sprites) {
                    sprite.replaceColor(0xff000084, ((save != null && save.data.config != null) ? save.data.config.get("windowColor") : 0xff000037), false);
                }
            case 1:
                for (sprite in sprites) {
                    sprite.replaceColor(0xffa3a3a3, 0xff424242, false);
                    sprite.replaceColor(0xffffffff, 0xff7b7b7b, false);
                }
            case 2:
                for (sprite in sprites) {
                    sprite.replaceColor(0xffa3a3a3, 0xff00a500, false);
                    sprite.replaceColor(0xffffffff, 0xffffde00, false);
                }
            case 3:
                for (sprite in sprites) {
                    sprite.replaceColor(0xffa3a3a3, 0xffff3a84, false);
                    sprite.replaceColor(0xffffffff, 0xffff9c5a, false);
                }
            case 4:
                for (sprite in sprites) {
                    sprite.replaceColor(0xff000084, 0xff000037, false);
                }
        }
    }

    var entering:Bool = false;
    var enterSpeed:Int = 1;
    var frameStep:Int = 0;
    public function enter(speed:Int = 1) {
        frameStep = 0;
        enterSpeed = speed;
        if (enterMask != null) {
            enterMask.kill();
            enterMask.destroy();
        }
        enterMask = new FlxSprite(0,8).makeGraphic((_width*8)+8, (_height*8)+8, 0x00ff0000);
        add(enterMask);
        entering = true;
    }
}