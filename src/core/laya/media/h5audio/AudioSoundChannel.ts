import { Laya } from "./../../../Laya";
import { Event } from "../../events/Event"
	import { SoundChannel } from "../SoundChannel"
	import { SoundManager } from "../SoundManager"
	import { Render } from "../../renders/Render"
	import { Browser } from "../../utils/Browser"
	import { Pool } from "../../utils/Pool"
	import { Utils } from "../../utils/Utils"
	
	/**
	 * @private
	 * audio标签播放声音的音轨控制
	 */
	export class AudioSoundChannel extends SoundChannel {
		
		/**
		 * 播放用的audio标签
		 */
		private _audio:Audio = null;
		private _onEnd:Function;
		private _resumePlay:Function;
		
		constructor(audio:Audio){
			super();
			this._onEnd = Utils.bind(this.__onEnd, this);
			this._resumePlay = Utils.bind(this.__resumePlay, this);
			audio.addEventListener("ended", this._onEnd);
			this._audio = audio;
		}
		
		private __onEnd():void {
			if (this.loops == 1) {
				if (this.completeHandler) {
					Laya.systemTimer.once(10, this, this.__runComplete, [this.completeHandler], false);
					this.completeHandler = null;
				}
				this.stop();
				this.event(Event.COMPLETE);
				return;
			}
			if (this.loops > 0) {
				this.loops--;
			}
			this.startTime = 0;
			this.play();
		}
		
		private __resumePlay():void {		
			if (this._audio) this._audio.removeEventListener("canplay", this._resumePlay);
			if (this.isStopped) return;
			try {
				this._audio.currentTime = this.startTime;
				Browser.container.appendChild(this._audio);
				this._audio.play();
			} catch (e) {
				//this.audio.play();
				this.event(Event.ERROR);
			}
		}
		
		/**
		 * 播放
		 */
		/*override*/  play():void {
			this.isStopped = false;
			try {
				this._audio.playbackRate = SoundManager.playbackRate;
				this._audio.currentTime = this.startTime;
			} catch (e) {
				this._audio.addEventListener("canplay", this._resumePlay);
				return;
			}
			SoundManager.addChannel(this);
			Browser.container.appendChild(this._audio);
			if("play" in this._audio)
			this._audio.play();
		}
		
		/**
		 * 当前播放到的位置
		 * @return
		 *
		 */
		/*override*/  get position():number {
			if (!this._audio)
				return 0;
			return this._audio.currentTime;
		}
		
		/**
		 * 获取总时间。
		 */
		/*override*/  get duration():number 
		{
			if (!this._audio)
				return 0;
			return this._audio.duration;
		}
		
		/**
		 * 停止播放
		 *
		 */
		/*override*/  stop():void {
			//trace("stop and remove event");
			super.stop();
			this.isStopped = true;
			SoundManager.removeChannel(this);
			this.completeHandler = null;
			if (!this._audio)
				return;
			if ("pause" in this._audio)
			//理论上应该全部使用stop，但是不知为什么，使用pause，为了安全我只修改在加速器模式下再调用一次stop
			if ( Render.isConchApp ){
				this._audio.stop();
			}
			this._audio.pause();
			this._audio.removeEventListener("ended", this._onEnd);
			this._audio.removeEventListener("canplay", this._resumePlay);
			//ie下使用对象池可能会导致后面的声音播放不出来
			if (!Browser.onIE)
			{
				if (this._audio!=AudioSound._musicAudio)
				{
					Pool.recover("audio:" + this.url, this._audio);
				}
			}		
			Browser.removeElement(this._audio);
			this._audio = null;
		
		}
		
		/*override*/  pause():void 
		{
			this.isStopped = true;
			SoundManager.removeChannel(this);
			if("pause" in this._audio)
			this._audio.pause();
		}
		
		/*override*/  resume():void 
		{		
			if (!this._audio)
				return;
			this.isStopped = false;
			SoundManager.addChannel(this);
			if("play" in this._audio)
			this._audio.play();
		}
		
		/**
		 * 设置音量
		 * @param v
		 *
		 */
		/*override*/  set volume(v:number) {
			if (!this._audio) return;
			this._audio.volume = v;
		}
		
		/**
		 * 获取音量
		 * @return
		 *
		 */
		/*override*/  get volume():number {
			if (!this._audio) return 1;
			return this._audio.volume;
		}
	
	}

