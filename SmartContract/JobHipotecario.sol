using Neo.SmartContract.Framework;
using Neo.SmartContract.Framework.Services.Neo;

namespace Neo.SmartContract
{
    public class dominio : Framework.SmartContract
    {
        
        public static readonly byte[] Owner1 = "ATrzHaicmhRj15C3Vv6e6gLfLqhSD2PtTr".ToScriptHash(); //Banco
        public static readonly byte[] Owner2 = "ksjsh3434GekkwHkewrjeDjjjhhhehe".ToScriptHash(); // Ejecutivo Hipotecario
        public static readonly byte[] Owner3 = "LSDKF6KSDKJJJksjhsdfsshdggd".ToScriptHash();  // Notaria
        public static readonly byte[] Owner4 = "ssfdfghhJHggfffdDDFHJJJHGFg".ToScriptHash(); // CBRS
        public static readonly byte[] Owner5 = "2k2h2gksjhshgsgsgsggfffdfsss".ToScriptHash(); // INMOBILIARIA - FINALIZA SOLICITUD - FIN DEL PROCESO
        

        [DisplayName("transfer")]
        public static event Action<byte[], byte[], object[]> Transferred;

        public static object Main(string operation, params object[] args)
        {
          
         if (Runtime.Trigger == TriggerType.Application)
           {
                 if (operation == "ConsultarprocesoCredito") //Usuario consulta el proceso de su credito
                  {
                    if (args.Length != 1) return 0;
                    String[] procesoHipo = (byte[])args[0];
                    return Consulta(procesoHipo);
                  }

                 if (operation == "IngresarHipoInicial")  //Inicia la solicitud de Hipotecario (Banco)
                  {
                    if (args.Length != 4) return false;
                    byte[] Owner = (byte[])args[0];    // Entidad 1
                  
                    return IngresarHipoInicial(Owner, args); // 
                  }
             
                if (operation == "TraspasarSolProceso")  //Inicia la solicitud de Hipotecario (Banco) Cambios de proceso
                  {
                    if (args.Length != 5) return false;
                    byte[] from = (byte[])args[0];    // Entidad 1
                    byte[] to = (byte[])args[1];      // Entidad 2
                   

                    return Transfiere(from, to, args); //Traspaso el trabajo a otra entidad (Siguiente en el proceso hipotecario)
                  }
                if (operation == "EliminarSolProceso") 
                    byte[] Owner = Owner1
                   return EliminarSolHipo(Owner);
             
             return false;
           }
        }

        private static byte[] Consulta(byte[] address) // Consulto proceso de progreso (Entidad quien la tiene)
        {
             return Storage.Get(Storage.CurrentContext, address).AsInteger();
        }

        private static bool IngresarHipoInicial(byte[] owner,object[] args)
        {
             if (args.Length != 3)
                return false;

             if (!Runtime.CheckWitness(owner)) return false;

             int idOperacion = (int)args[1];    
             string proceso = (string)args[2];
             string fechaaccion = (string)args[3];

    
            object[] DatosHipo = new object[3];
            DatosHipo[0] = idOperacion;    
            DatosHipo[1] = fechaAccion;        
            DatosHipo[2] = proceso;      

            byte[] DatosHipo_storage = DatosHipo.Serialize();

            Storage.Put(Storage.CurrentContext, owner, DatosHipo_storage);

            return true;
        }

       private static bool Transfiere(byte[] from, byte[] to, object[] args)
        {
            int IdOperacion = (int)args[2]; // Id de operacion 
            string proceso = (string)args[3];
            string fechaaccion = (string)args[4];


           // if (proceso != 3) return false;
            if (!Runtime.CheckWitness(from)) return false;
            if (from == to) return true;


             byte[] from_datos = Storage.Get(Storage.CurrentContext, from);

             object[] datos = (object[])from_datos.Deserialize();

            if (datos[2] == 111) //  si todos los procesos estan ok para este owner entonces
            {

                byte[] datos_storage = args.Serialize();
                Storage.Put(Storage.CurrentContext, from, datos_storage);

                  args[2] = IdOperacion
                  args[3] = 000  // Inicia con estado 0
                  args[4] = fechaaccion

              

                byte[] to_datos = Storage.Get(Storage.CurrentContext, to);

                Storage.Put(Storage.CurrentContext, to, to_datos);

                Transferred(from, to, value);
            return true;
            }

            // bool authorized = false;
             //if (!authorized)
            //{

           // }

           // return true;
        }

       private static bool EliminarSolHipo(byte[] Owner)
        {
   //       byte[] owner = Storage.Get(Storage.CurrentContext, dominio);
          if (owner == null) return false;
          if (!Runtime.CheckWitness(owner)) return false;
          Storage.Delete(Storage.CurrentContext, Owner);
          return true;
        }
    }
}
