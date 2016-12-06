package
{
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageAlign;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.SoundTransform;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.net.NetStream;
import flash.utils.ByteArray;
import TemporaryItems_flash1239_fla_fla.*;

import flash.utils.setTimeout;


public class Player  extends Sprite {
    private var urlStream:URLStream;
    private var netStream:NetStream;
    private var playButton:Play_Button_12;
    private var pauseButton:Pause_Button_16;
    private var soundButton:Stop_Button_18;

    public function Player() {
        this.generateNetStream();
        this.generateVideo();
        this.loadVideo();
        this.viewInit();
    }

    public function onMetaData(info:Object):void {
    }

    public function onPlayStatus(status:Object):void {
    }

    private function loadVideo():void {
        var url:String = "http://video.xinjie.hou/test.flv";
        var urlRequest:URLRequest = new URLRequest(url);
        this.urlStream = new URLStream();
        this.urlStream.addEventListener(Event.COMPLETE, downloadCompleteHandler);
        this.urlStream.load(urlRequest);
    }

    private function viewInit():void {
        this.stage.scaleMode = StageScaleMode.NO_SCALE;
        this.stage.align = StageAlign.TOP_LEFT;
        this.generatePlayButton();
        this.generatePauseButton();
        this.generateSoundButton();
    }

    private function generateVideo():void{
        var video:Video = new Video(880, 500);
        this.addChild(video);
        video.attachNetStream(this.netStream);
        this.netStream.bufferTime = 1;
        this.netStream.receiveAudio(true);
        this.netStream.receiveVideo(true);
        this.netStream.play(null);
    }

    private function generateNetStream():void{
        var netConnection:NetConnection = new NetConnection();
        netConnection.connect(null);
        this.netStream = new NetStream(netConnection);
        this.netStream.client = this;
    }

    private function generatePlayButton():void{
        this.playButton = new Play_Button_12();
        this.playButton.y = 475;
        this.playButton.visible = false;
        this.addChild(this.playButton);
        this.playButton.addEventListener(MouseEvent.CLICK, this.playButtonHandler);
    }

    private function generatePauseButton():void{
        this.pauseButton = new Pause_Button_16();
        this.pauseButton.y = 475;
        this.addChild(this.pauseButton);
        this.pauseButton.addEventListener(MouseEvent.CLICK, this.pauseButtonHandler);
    }

    private function generateSoundButton():void{
        this.soundButton = new Stop_Button_18();
        this.soundButton.y = 475;
        this.soundButton.x = 40;
        this.addChild(this.soundButton);
        this.soundButton.addEventListener(MouseEvent.CLICK, this.soundButtonHandler);
    }

    private function downloadCompleteHandler(event:Event):void {
        var bytes:ByteArray = new ByteArray();
        this.urlStream.readBytes(bytes);
        this.netStream.appendBytes(bytes);

    }

    private function playButtonHandler(event:MouseEvent):void {
        this.netStream.resume();
        this.playButton.visible = false;
        this.pauseButton.visible = true;
    }

    private function pauseButtonHandler(event:MouseEvent):void {
        this.netStream.pause();
        this.pauseButton.visible = false;
        this.playButton.visible = true;
    }

    private function soundButtonHandler(event:MouseEvent):void{

        this.stage.displayState = StageDisplayState.FULL_SCREEN;
        var transform:SoundTransform = this.netStream.soundTransform;
        trace(transform.volume);
        transform.volume -= 0.05;
        this.netStream.soundTransform = transform;
        trace('click');

    }
}
}