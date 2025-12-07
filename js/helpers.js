import PocketBase from 'https://cdn.jsdelivr.net/npm/pocketbase@0.21.5/+esm';

const pb = new PocketBase('https://3.138.193.102:8090/');
//const pb = new PocketBase('http://127.0.0.1:8090');

const defaultLoadCMSDataOnHtml = (records) => {
  const contentDiv = document.getElementById('content');
    
  contentDiv.innerHTML = '';

  records.forEach(record => {
    const title = record.title ? `<h1>${record.title}</h1>` : undefined;
    const memberHTML = `${title || ''} <p>${record.text}</p>`;
    contentDiv.innerHTML += memberHTML;
  });

}


export async function loadCMSData(pbFilters = {type: "", filter: "", sort: "created"}, loadCMSDataOnHtml = defaultLoadCMSDataOnHtml) {
  try {
    let params = {}
    const collection = pbFilters.type || ''

    if (pbFilters) {
      params = {...pbFilters}
    }

    params.filter = ""
    const records = await pb.collection(collection).getFullList(params);

    loadCMSDataOnHtml(records);
    
  } catch (error) {
    console.error('Erro ao carregar membros:', error);
    document.getElementById('content').innerHTML = '<p>Erro ao carregar os membros. Por favor, tente novamente mais tarde.</p>';
  }
}


