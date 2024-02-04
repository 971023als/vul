
// JSON 데이터를 웹 페이지에 로드하기
// 캐시를 우회하기 위해 타임스탬프를 쿼리 파라미터로 추가
const url = 'results.json?_=' + new Date().getTime();

fetch(url)
.then(response => response.json())
.then(data => fillTable(data))
.catch(error => console.error('Error loading JSON data:', error));

function fillTable(data) {
    const tableBody = document.querySelector("#results table tbody");
    Object.keys(data).forEach((key, index) => {
        const entry = data[key];
        const tr = document.createElement('tr');
        tr.innerHTML = `
        <td>${key}</td>
        <td>${entry.분류}</td>
        <td>${entry.위험도}</td>
        <td>${entry.진단항목}</td>
        <td>${entry.진단결과}</td>
        <td>${entry.현황.join('<br>')}</td>
        <td>${entry.대응방안}</td>
        <td>${entry.생성시간}</td>
        `;
        tableBody.appendChild(tr);
    });
}

