package
{
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.media.Video;
import flash.net.NetConnection;
import flash.net.URLRequest;
import flash.net.URLStream;
import flash.net.NetStream;
import flash.utils.ByteArray;


public class Player  extends Sprite
{
    private var urlStream:URLStream;
    private var netStream:NetStream;
    public function Player()
    {
        stage.scaleMode = StageScaleMode.NO_BORDER;
        stage.align = StageAlign.TOP_LEFT;
        var netConnection:NetConnection = new NetConnection();
        netConnection.connect(null);
        this.netStream = new NetStream(netConnection);
        this.netStream.client = this;
        var video:Video = new Video(stage.stageWidth, stage.stageHeight);
        addChild(video);
        video.attachNetStream(this.netStream);
        this.netStream.bufferTime = 1;
        this.netStream.receiveAudio(true);
        this.netStream.receiveVideo(true);
        this.netStream.play(null);
        this.loadVideo();
    }

    public function onMetaData(info:Object):void{
    }

    public function onPlayStatus(status:Object):void{
    }

    private function loadVideo():void{
        var url:String = "http://video.xinjie.hou/test.flv";
        var urlRequest:URLRequest = new URLRequest(url);
        this.urlStream = new URLStream();
        this.urlStream.addEventListener(Event.COMPLETE, downloadCompleteHandler);
        this.urlStream.load(urlRequest);
    }

    private function downloadCompleteHandler(event:Event):void {
        var bytes:ByteArray = new ByteArray();
        this.urlStream.readBytes(bytes);

        this.netStream.appendBytes(bytes);

    }
}
}