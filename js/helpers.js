import PocketBase from 'https://cdn.jsdelivr.net/npm/pocketbase@0.21.5/+esm';

const pb = new PocketBase('http://127.0.0.1:8090');

const defaultLoadCMSDataOnHtml = (records) => {
  const contentDiv = document.getElementById('content');
    
    contentDiv.innerHTML = '';
  
    records.forEach(record => {
      const memberHTML = `<h1>${record.title || 'Sem título'}</h1> ${record.text}`;
      contentDiv.innerHTML += memberHTML;
    });

}


export async function loadCMSData(pbfilter = {type: "", filter: "", sort: "created"}, loadCMSDataOnHtml = defaultLoadCMSDataOnHtml) {
  try {
    const records = await pb.collection(pbfilter.type).getFullList();

    loadCMSDataOnHtml(records);
    
  } catch (error) {
    console.error('Erro ao carregar membros:', error);
    document.getElementById('content').innerHTML = '<p>Erro ao carregar os membros. Por favor, tente novamente mais tarde.</p>';
  }
}


