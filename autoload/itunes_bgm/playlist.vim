scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:V = itunes_bgm#get_vital()
let s:Random = s:V.import("Random")


let s:play_list = {
\	"list" : [],
\	"history" : [],
\	"mplayer" : itunes_bgm#mplayer#make(),
\	"now_music" : {},
\	"_is_stop" : 1,
\}
function! s:play_list.start()
	if empty(self.list)
		return
	endif
	call self.play()
endfunction


function! s:play_list.play(...)
	let music = get(a:, 1, self.get_next())
	let self.now_music = music
	if empty(self.now_music)
		return
	endif
	let self._is_stop = 0
	call self.mplayer.play(self.now_music.previewUrl)
	call add(self.history, self.now_music)
	let self.history = self.history[:100]
endfunction


function! s:play_list.play_next()
	call self.play(self.get_next())
endfunction


function! s:play_list.get_next()
	if empty(self.list)
		return {}
	endif
	return s:Random.sample(self.list)
endfunction


function! s:play_list.is_stop()
	return get(self, "_is_stop", 0)
endfunction


function! s:play_list.stop()
	let self._is_stop = 1
	call self.mplayer.exit()
endfunction


function! itunes_bgm#playlist#make()
	return deepcopy(s:play_list)
endfunction


let &cpo = s:save_cpo
unlet s:save_cpo
