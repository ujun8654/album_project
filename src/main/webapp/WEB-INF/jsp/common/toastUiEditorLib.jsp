<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/toastui-editor.min.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/tui-color-picker/latest/tui-color-picker.min.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/editor-plugin-color-syntax/latest/toastui-editor-plugin-color-syntax.min.css" />
<link rel="stylesheet" href="https://uicdn.toast.com/editor/latest/theme/toastui-editor-dark.min.css" />
<script src="https://uicdn.toast.com/tui-color-picker/latest/tui-color-picker.min.js"></script>
<script src="https://uicdn.toast.com/editor/latest/toastui-editor-all.min.js"></script>
<script src="https://uicdn.toast.com/editor-plugin-color-syntax/latest/toastui-editor-plugin-color-syntax.min.js"></script>

<script>
	const { Editor } = toastui;
	const { colorSyntax } = Editor.plugin;
	
	let toastEditor = null;
	
	$(function(){
		const initialValueEl = $('#toast-ui-editor > div');
		const initialValue = initialValueEl.length == 0 ? '' : initialValueEl.html().trim();
		
		const theme = localStorage.getItem("theme") ?? "light";
		
		const editor = new Editor({
		  el: document.querySelector('#toast-ui-editor'),
		  previewStyle: 'tab',
		  height: '500px',
		  initialEditType: 'markdown',
		  initialValue: initialValue,
		  theme: theme,
		  plugins: [colorSyntax]
		});
		
		toastEditor = editor;
	})
	
	const submitForm = function (form) {
		const markdown = toastEditor.getMarkdown().trim();
		
		form.title.value = form.title.value.trim();
		
		if (form.title.value.length == 0) {
			alert('제목을 입력해주세요');
			form.title.focus();
			return false;
		}
		
		if (markdown.length == 0) {
			alert('내용을 입력해주세요');
			toastEditor.focus();
			return false;
		}
		
		form.content.value = markdown;
		return true;
	}
</script>