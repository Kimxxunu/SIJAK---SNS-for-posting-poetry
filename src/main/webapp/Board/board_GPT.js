// 채팅 메시지를 표시할 DOM
const chatMessages = document.querySelector('#chat-messages');
// 사용자 입력 필드
const userInput = document.querySelector('.Board_GPT_Page-Body-Form-InputMessage input');
// 전송 버튼
const sendButton = document.querySelector('.Board_GPT_Page-Body-Form-Submit');
// 발급받은 OpenAI API 키를 변수로 저장
const apiKey = 'GPT API키 입력';
// OpenAI API 엔드포인트 주소를 변수로 저장
const apiEndpoint = 'https://api.openai.com/v1/chat/completions';

// 메시지 추가 함수
function addMessage(sender, message) {
    const messageElement = document.createElement('div');
    messageElement.className = 'message';
    messageElement.innerHTML = `<p>${message}</p>`;
    chatMessages.prepend(messageElement);
}

// 챗봇 메시지 추가 함수
function addGPTMessage(sender, message) {
    const GPTMessageBox = document.createElement('div');
    GPTMessageBox.className = 'GPTmessageBox';
    
    const messageElement = document.createElement('div');
    messageElement.className = 'GPTmessage';

    const firstLineEndIndex = message.indexOf('\n');
    let firstLine, remainingMessage;
    
    if (firstLineEndIndex !== -1) {
        firstLine = message.slice(0, firstLineEndIndex);
        remainingMessage = message.slice(firstLineEndIndex + 1);
    } else {
        firstLine = message;
        remainingMessage = '';
    }

    messageElement.innerHTML = `<p><span class="first-line">${sender} ${firstLine}</span><br>${remainingMessage.replace(/\n/g, '<br>')}</p>`;
    
    const messageselect = document.createElement('button');
    messageselect.className = 'select';
    messageselect.type = 'button';
    messageselect.textContent = "이 시가 맘에 드나요?";
    
    GPTMessageBox.appendChild(messageElement);
    GPTMessageBox.appendChild(messageselect);
    chatMessages.prepend(GPTMessageBox);

    messageselect.addEventListener('click', () => {
        // 로컬 스토리지에 제목과 내용을 저장
        localStorage.setItem('gptTitle', firstLine);
        localStorage.setItem('gptContent', remainingMessage);
        
        // 새 페이지로 이동
        window.location.assign('./board_create.jsp');
    });
}

// ChatGPT API 요청
async function fetchAIResponse(prompt) {
    const requestOptions = {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json',
            'Authorization': `Bearer ${apiKey}`
        },
        body: JSON.stringify({
            model: "gpt-3.5-turbo",
            messages: [{
                role: "user",
                content: prompt
            }],
            temperature: 0.8,
            max_tokens: 1024,
            top_p: 1,
            frequency_penalty: 0.5,
            presence_penalty: 0.5
        }),
    };

    try {
        const response = await fetch(apiEndpoint, requestOptions);
        const data = await response.json();
        
        console.log('API Response:', data); // 응답 로그 출력

        if (response.ok && data.choices && data.choices.length > 0) {
            return data.choices[0].message.content;
        } else {
            console.error('Unexpected API response:', data);
            return 'Unexpected API response';
        }
    } catch (error) {
        console.error('OpenAI API 호출 중 오류 발생:', error);
        return `OpenAI API 호출 중 오류 발생: ${error.message}`;
    }
}

// 전송 중인지 확인하기 위한 플래그
let isSending = false;

// 메시지 전송 함수
async function sendMessage() {
    if (isSending) return; // 이미 전송 중이면 중복 호출 방지
    isSending = true;
    
    const message = userInput.value.trim();
    if (message.length === 0) {
        isSending = false;
        return;
    }
    
    addMessage('나', message);
    userInput.value = '';
    
    const aiResponse = await fetchAIResponse(message + " 라는 주제로 시 한편을 작성해줘 제목까지 지어줘 근데 제목쓸때는 '제목:' 이런거 붙이지 말고");
    addGPTMessage('', aiResponse);
    
    isSending = false;
}

// 전송 버튼 클릭 이벤트 처리
sendButton.addEventListener('click', sendMessage);

// 입력 필드에서 엔터 키 감지
userInput.addEventListener('keydown', async (event) => {
    if (event.key === 'Enter') {
        event.preventDefault(); // 엔터 키 기본 동작 방지
        sendMessage();
    }
});
