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
        
        public static object Main(string operation, params object[] args)
        {
          
         if (Runtime.Trigger == TriggerType.Application)
           {
                 if (operation == "ConsultarEstadoCredito") //Usuario consulta el estado de su credito
                  {
                    if (args.Length != 1) return 0;
                    String[] EstadoHipo = (byte[])args[0];
                    return Consulta(EstadoHipo);
                  }

                 if (operation == "IngresarHipoInicial")  //Inicia la solicitud de Hipotecario (Banco)
                  {
                    if (args.Length != 4) return false;
                    byte[] Owner = (byte[])args[0];    // Entidad 1
                    int idOperacion = (int)args[1];    
                    string estado = (string)args[2];
                    string fechaaccion = (string)args[3];
                    return IngresarHipoInicial(Owner, idOperacion, estado,fechaaccion); // 
                  }
             
                if (operation == "TraspasarSolProceso")  //Inicia la solicitud de Hipotecario (Banco) Cambios de estado
                  {
                    if (args.Length != 5) return false;
                    byte[] from = (byte[])args[0];    // Entidad 1
                    byte[] to = (byte[])args[1];      // Entidad 2
                    int IdOperacion = (int)args[2]; // Id de operacion 
                    string estado = (string)args[3];
                    string fechaaccion = (string)args[4];

                    return Transfiere((from, to, IdOperacion,estado,fechaaccion); //Traspaso el trabajo a otra entidad (Siguiente en el proceso hipotecario)
                  }
                if (operation == "EliminarSolProceso") 
                    byte[] Owner = Owner1
                   return EliminarSolHipo(Owner);
             
             return false;
           }
        }

        private static byte[] Consulta(byte[] address) // Consulto estado de progreso (Entidad quien la tiene)
        {
             return Storage.Get(Storage.CurrentContext, address).AsInteger();
        }

        private static bool IngresarHipoInicial(byte[] owner,int idOperacion, string estado, string fechaaccion)
        {
            if (!Runtime.CheckWitness(owner)) return false;

                object[] DatosHipo = new object[4];
                DatosHipo[0] = idOperacion;    
                DatosHipo[1] = fechaAccion;        
                DatosHipo[2] = estado;      

            byte[] DatosHipo_storage = DatosHipo.Serialize();

            Storage.Put(Storage.CurrentContext, owner, DatosHipo_storage);

            return true;
        }

       private static bool Transfiere(byte[] from, byte[] to, BigInteger value)
        {
            if (!Runtime.CheckWitness(to)) return false;
            byte[] from = Storage.Get(Storage.CurrentContext, dominio);
            if (from == null) return false;
            if (!Runtime.CheckWitness(from)) return false;
            Storage.Put(Storage.CurrentContext, dominio, to);
            return true;
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
