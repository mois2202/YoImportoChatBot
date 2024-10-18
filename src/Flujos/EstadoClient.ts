import {ExecuteSP,ExecuteSPR} from '../Modulos/SPs/Sps'

function IsExistClient(Numb: string): boolean {
    ExecuteSPR('get_Is_Exist_Client', [Numb]);
    return true
}