/// <reference path="../pb_data/types.d.ts" />

onRecordAfterCreate("contact_messages", async (e) => {
    const msg = e.record;
    
    try {
        await $app.mailer.send({
            from: "tiago.espanha@gmail.com",
            to: "tiagoespanha@id.uff.br", 
            subject: `Nova mensagem do formulário (${msg.email})`,
            text: `
                Nova mensagem recebida:

                Nome: ${msg.name}
                Email: ${msg.email}
                Mensagem:
                ${msg.message}
            `
        });

        console.log("📧 Email enviado com sucesso!");
    } catch (err) {
        console.error("❌ Erro ao enviar email:", err);
    }
});
