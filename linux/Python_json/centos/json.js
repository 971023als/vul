
// JSON 데이터를 웹 페이지에 로드하기
fetch('results.json')
.then(response => response.json())
.then(data => fillTable(data))
.catch(error => console.error('Error loading JSON data:', error));

function fillTable(data) {
    const table = document.querySelector("table"); // <table> 태그 선택
    for (const key in data) {
        if (data.hasOwnProperty(key)) {
            const entry = data[key];
            const tr = document.createElement('tr'); // 새 행(tr) 생성
            tr.innerHTML = `
                <td>${key}</td>
                <td>${entry.분류}</td>
                <td>${entry.위험도}</td>
                <td>${entry.진단항목}</td>
                <td>${entry.진단결과}</td>
                <td>${entry.현황.join('<br>')}</td>
                <td>${entry.대응방안}</td>
            `;
            table.appendChild(tr); // 생성된 행을 테이블에 추가
        }
    }
}
